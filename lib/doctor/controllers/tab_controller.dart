import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorTabController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    changeNotifier.stringStream.listen((String data) {
      if (data == "Done") {
        SharedPrefs.getUser().then((value) {
          if (value != null) {
            ConnectycubeFlutterCallKit.instance.init(
              onCallAccepted: onCallAcceptedWhenTerminated,
              onCallRejected: onCallRejectedWhenTerminated,
            );

            // initForegroundService();

            checkSystemAlertWindowPermission();

            CallManager.instance.init(Get.context!);

            PushNotificationsManager.instance.init();
            ConnectycubeFlutterCallKit.onCallAcceptedWhenTerminated =
                onCallAcceptedWhenTerminated;
            ConnectycubeFlutterCallKit.onCallRejectedWhenTerminated =
                onCallRejectedWhenTerminated;
          }
        });
      }
    });
    notificationHelper.initialize();
    callNotification();
  }

  callNotification() async {
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessage.listen((message) {
      var payloadData =
          '${message.data['notificationType']}:${message.data['ccId']}';

      if (message.data[PARAM_CALLER_NAME] != null) {
        incomingCallManager.setValue(message.data[PARAM_CALLER_NAME],
            message.data[PARAM_CALLER_IMAGE] ?? "");
      }

      if ((message.data['signal_type'] != null) &&
          (message.data['signal_type'] == "rejectCall")) {
        if (message.data['signal_type'] == "rejectCall") {
          try {
            CallManager.instance.reject(message.data['session_id'], true);
          } catch (e) {}
        }
      } else if (message.data['order_id'] != null) {
        notificationHelper.showNotification(
          title: message.notification!.title,
          body: message.notification!.body,
          payload: "${message.data['type']}:${message.data['order_id']}",
          id: "124",
        );
      } else if (payloadData.split(":")[0].toString() == '3') {
        notificationHelper.showNotification(
          title: 'Call Rejected',
          body: message.notification!.body,
          payload: payloadData,
          id: "124",
        );
        try {
          Get.to(() => Container());
          CallManager.instance.reject(message.data['sessionId'], true);
        } catch (e) {}
      } else if (payloadData.split(":")[0].toString() == '1') {
        incomingCallManager.setValue(
            message.data[PARAM_CALLER_NAME], message.data['image']);
      } else {
        if (message.notification?.title != null) {
          notificationHelper.showNotification(
            title: message.notification!.title ?? "",
            body: message.notification!.body ?? "",
            payload: "${message.data['myid']}:${message.data['myUserName']}",
            id: "124",
          );
        }
      }
    });

    RemoteMessage? initialMessage = await firebaseMessaging.getInitialMessage();

    if (initialMessage != null) {
      if (initialMessage.data['myUserName'] != null &&
          initialMessage.data['myid'] != null) {
        await Get.toNamed(Routes.chatScreen, arguments: {
          'userName': initialMessage.data['myUserName'].toString(),
          'uid': initialMessage.data['myid'].toString(),
          'isUser': initialMessage.data['myid'].toString().contains("100")
              ? false
              : true,
        });
        Get.delete<ChatController>();
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      if (message.data['type'] == "user_id") {
        Get.toNamed(Routes.uAppointmentDetailScreen,
            arguments: {'id': message.data['order_id'].toString()});
      } else if (message.data['type'] == "doctor_id") {
        await Get.toNamed(Routes.dAppointmentDetailScreen,
            arguments: {'id': message.data['order_id'].toString()});
        Get.delete<DAppointmentDetailsController>();
      }
    });
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return DoctorDashboard();
      case 1:
        return DoctorPastAppointments();
      case 2:
        return DoctorProfile();
      case 3:
        return ChatListScreen();
      case 4:
        return MoreInfoScreen();
    }
  }

  RxInt index = 0.obs;

  Future<bool> willPopScope() async {
    exit(0);
  }
}
