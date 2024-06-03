import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class IncomingCallController extends GetxController{
  final P2PSession callSession = Get.arguments['callSession'];
  static const String TAG = "IncomingCallScreen";

  IncomingManageController incomingScreenManager = Get.find();

  getCallTitle() {
    var callType;

    switch (callSession.callType) {
      case CallType.VIDEO_CALL:
        callType = "Video";
        break;
      case CallType.AUDIO_CALL:
        callType = "Audio";
        break;
    }

    return "Incoming $callType call";
  }

  void acceptCall(BuildContext context, P2PSession callSession) {
    FlutterRingtonePlayer.stop();
    CallManager.instance.acceptCall(callSession.sessionId,false);
  }

  void rejectCall(BuildContext context, P2PSession callSession) {
    FlutterRingtonePlayer.stop();
    CallManager.instance.reject(callSession.sessionId,false);
  }

  Future<bool> onBackPressed(BuildContext context) {
    return Future.value(false);
  }
}