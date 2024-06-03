import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

final incomingCallManager = Get.put(IncomingManageController());

Future myBackgroundMessageHandler(RemoteMessage event) async {
  var payloadData =
      '${event.data['notificationType']}:${event.data['ccId']}:${event.data['myid']}:${event.data['myUserName']}';

  if (event.data['signal_type'] == 'endCall') {
    ConnectycubeFlutterCallKit.reportCallEnded(
        sessionId: event.data['session_id']);
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: false);
  }

  if (event.data[PARAM_CALLER_NAME] != null) {
    incomingCallManager.setValue(
        event.data[PARAM_CALLER_NAME], event.data[PARAM_CALLER_IMAGE] ?? "");
  }

  if ((event.data['signal_type'] != null) &&
      (event.data['signal_type'] == "rejectCall")) {
    if (event.data['signal_type'] == "rejectCall") {
      try {
        CallManager.instance.reject(event.data['session_id'], true);
      } catch (e) {}
    }
  }

  if ((event.data['signal_type'] != null) &&
      (event.data['signal_type'] == "startCall")) {
    var tmpOppId = int.parse(event.data[PARAM_CALL_OPPONENTS]);
    CallEvent callEvent = CallEvent(
        sessionId: event.data[PARAM_SESSION_ID],
        callType: int.parse(event.data[PARAM_CALL_TYPE]),
        callerId: int.parse(event.data[PARAM_CALLER_ID]),
        callerName: event.data[PARAM_CALLER_NAME],
        callPhoto: event.data[PARAM_CALLER_IMAGE],
        opponentsIds: {tmpOppId},
        userInfo: {'token': '${event.data['mytoken']}'});
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);
    ConnectycubeFlutterCallKit.showCallNotification(callEvent);
  }

  if (payloadData.split(":")[0].toString() == '1') {
    var tmpOppId = int.parse(event.data[PARAM_CALL_OPPONENTS]);
    CallEvent callEvent = CallEvent(
        sessionId: event.data[PARAM_SESSION_ID],
        callType: int.parse(event.data[PARAM_CALL_TYPE]),
        callerId: int.parse(event.data[PARAM_CALLER_ID]),
        callerName: event.data[PARAM_CALLER_NAME],
        callPhoto: event.data[PARAM_CALLER_IMAGE],
        opponentsIds: {tmpOppId},
        userInfo: {'token': '${event.data['mytoken']}'});
    ConnectycubeFlutterCallKit.setOnLockScreenVisibility(isVisible: true);
    ConnectycubeFlutterCallKit.showCallNotification(callEvent);
  } else if (payloadData.split(":")[0].toString() == '3') {
    notificationHelper.showNotification(
      title: 'Call Rejected',
      body: event.notification!.body,
      payload: payloadData,
      id: "124",
    );
    try {
      CallManager.instance.reject(event.data['sessionId'], true);
    } catch (e) {}
  }
}
