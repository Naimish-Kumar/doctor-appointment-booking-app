import 'dart:convert';

import 'package:videocalling/services/localstorage_service.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:universal_io/io.dart';

import 'package:connectycube_sdk/connectycube_sdk.dart';

import '../utils/consts.dart';
import '../utils/pref_util.dart';
import 'package:videocalling/common/VideoCall/utils/configs.dart' as config;

class PushNotificationsManager {
  static const TAG = "PushNotificationsManager";

  static PushNotificationsManager? _instance;

  PushNotificationsManager._internal();

  static PushNotificationsManager _getInstance() {
    return _instance ??= PushNotificationsManager._internal();
  }

  factory PushNotificationsManager() => _getInstance();

  BuildContext? applicationContext;

  static PushNotificationsManager get instance => _getInstance();

  init() async {
    ConnectycubeFlutterCallKit.initEventsHandler();

    ConnectycubeFlutterCallKit.onTokenRefreshed = (token) {
      log('[onTokenRefresh] VoIP token: $token', TAG);
      subscribe(token);
    };

    ConnectycubeFlutterCallKit.getToken().then((token) {
      log('[getToken] VoIP token: $token', TAG);
      if (token != null) {
        subscribe(token);
      }
    });

    ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
        onCallRejectedWhenTerminated;
    ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
        onCallAcceptedWhenTerminated;
  }

  subscribe(String token) async {
    log('[subscribe] token: $token', PushNotificationsManager.TAG);

    var savedToken = await SharedPrefs.getSubscriptionToken();
    if (token == savedToken) {
      log('[subscribe] skip subscription for same token',
          PushNotificationsManager.TAG);
      return;
    }

    CreateSubscriptionParameters parameters = CreateSubscriptionParameters();

    parameters.pushToken = token;

    parameters.environment =
        kReleaseMode ? CubeEnvironment.PRODUCTION : CubeEnvironment.DEVELOPMENT;

    if (Platform.isAndroid) {
      parameters.channel = NotificationsChannels.GCM;
      parameters.platform = CubePlatform.ANDROID;
      parameters.bundleIdentifier = "doctor.finder.videocalling";
    } else if (Platform.isIOS) {
      parameters.channel = NotificationsChannels.APNS_VOIP;
      parameters.platform = CubePlatform.IOS;
      parameters.bundleIdentifier = "doctor.finder.videocalling";
    }

    var deviceInfoPlugin = DeviceInfoPlugin();

    var deviceId;

    if (kIsWeb) {
      var webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      deviceId = base64Encode(utf8.encode(webBrowserInfo.userAgent ?? ''));
    } else if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else if (Platform.isMacOS) {
      var macOsInfo = await deviceInfoPlugin.macOsInfo;
      deviceId = macOsInfo.computerName;
    }

    parameters.udid = deviceId;

    createSubscription(parameters.getRequestParameters())
        .then((cubeSubscriptions) {
      log('[subscribe] subscription SUCCESS', PushNotificationsManager.TAG);
      SharedPrefs.saveSubscriptionToken(token);
      for (var subscription in cubeSubscriptions) {
        if (subscription.device!.clientIdentificationSequence == token) {
          SharedPrefs.saveSubscriptionId(subscription.id!);
        }
      }
    }).catchError((error) {
      log('[subscribe] subscription ERROR: $error',
          PushNotificationsManager.TAG);
    });
  }

  Future<void> unsubscribe() {
    return SharedPrefs.getSubscriptionId().then((subscriptionId) async {
      if (subscriptionId != 0) {
        return deleteSubscription(subscriptionId).then((voidResult) {
          SharedPrefs.saveSubscriptionId(0);
        });
      } else {
        return Future.value();
      }
    }).catchError((onError) {
      log('[unsubscribe] ERROR: $onError', PushNotificationsManager.TAG);
    });
  }
}

@pragma('vm:entry-point')
Future<void> onCallRejectedWhenTerminated(CallEvent callEvent) async {
  await GetStorage.init();

  StorageService.removeData(key: LocalStorageKeys.callSessionCS);

  var currentUser = await SharedPrefs.getUser();
  initConnectycubeContextLess();

  var sendOfflineReject = rejectCall(callEvent.sessionId, {callEvent.callerId});
  var sendPushAboutReject = sendPushAboutRejectFromKilledState({
    PARAM_CALL_TYPE: callEvent.callType,
    PARAM_SESSION_ID: callEvent.sessionId,
    PARAM_CALLER_ID: callEvent.callerId,
    PARAM_CALLER_NAME: callEvent.callerName,
    PARAM_CALL_OPPONENTS: callEvent.opponentsIds.join(','),
  }, callEvent.callerId);

  return Future.wait([sendOfflineReject, sendPushAboutReject]).then((result) {
    return Future.value();
  });
}

@pragma('vm:entry-point')
Future<void> onCallAcceptedWhenTerminated(CallEvent callEvent) async {
  await GetStorage.init();

  try {
    StorageService.writeStringData(
        key: LocalStorageKeys.callSessionCS, value: callEvent.sessionId);
  } catch (e) {}
  return Future.value();
}

Future<void> sendPushAboutRejectFromKilledState(
  Map<String, dynamic> parameters,
  int callerId,
) {
  CreateEventParams params = CreateEventParams();
  params.parameters = parameters;
  params.parameters['message'] = "Reject call";
  params.parameters[PARAM_SIGNAL_TYPE] = SIGNAL_TYPE_REJECT_CALL;
  // params.parameters[PARAM_IOS_VOIP] = 1;

  params.notificationType = NotificationType.PUSH;
  params.environment = CubeEnvironment.DEVELOPMENT; 
  // bool isProduction = bool.fromEnvironment('dart.vm.product');
  // params.environment =
  //     isProduction ? CubeEnvironment.PRODUCTION : CubeEnvironment.DEVELOPMENT;
  params.usersIds = [callerId];

  return createEvent(params.getEventForRequest());
}

initConnectycubeContextLess() {
  CubeSettings.instance.applicationId = config.APP_ID;
  CubeSettings.instance.authorizationKey = config.AUTH_KEY;
  CubeSettings.instance.authorizationSecret = config.AUTH_SECRET;
  CubeSettings.instance.onSessionRestore = () {
    return SharedPrefs.getUser().then((savedUser) {
      return createSession(savedUser);
    });
  };
}
