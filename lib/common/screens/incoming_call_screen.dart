import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class IncomingCallScreen extends GetView<IncomingCallController> {
  final IncomingCallController callController =
      Get.put(IncomingCallController());
  @override
  Widget build(BuildContext context) {
    FlutterRingtonePlayer.playRingtone(
      looping: true,
      volume: 0.1,
      asAlarm: false,
    );
    callController.callSession.onSessionClosed = (callSession) {
      callController.incomingScreenManager.removeValue();
      callController.incomingScreenManager.removecallingImageValue();
      FlutterRingtonePlayer.stop();
      Get.back();
    };

    return WillPopScope(
        onWillPop: () => callController.onBackPressed(context),
        child: Scaffold(
            body: GetBuilder<IncomingManageController>(builder: (value) {
          return Container(
            decoration: BoxDecoration(
                image: (value.image == 'Default')
                    ? null
                    : value.image.contains('default-user.png')
                        ? DecorationImage(
                            image: AssetImage(value.image), fit: BoxFit.cover)
                        : DecorationImage(
                            image: NetworkImage(value.image),
                            fit: BoxFit.cover)),
            child: Container(
              color: value.image == 'Default'
                  ? null
                  : AppColors.BLACK.withOpacity(0.6),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(36),
                      child: Text(callController.getCallTitle(),
                          style: TextStyle(
                              fontSize: 20,
                              color: value.image == 'Default'
                                  ? AppColors.BLACK
                                  : AppColors.WHITE)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 36, bottom: 8),
                      child: Text(value.name,
                          style: TextStyle(
                              fontSize: 28,
                              color: value.image == 'Default'
                                  ? AppColors.BLACK
                                  : AppColors.WHITE)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 36, bottom: 8),
                      child: Text("Members:",
                          style: TextStyle(
                              fontSize: 20,
                              color: value.image == 'Default'
                                  ? AppColors.BLACK
                                  : AppColors.WHITE)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 86),
                      child: Text(
                          callController.callSession.callerId.toString(),
                          style: TextStyle(
                              fontSize: 18,
                              color: value.image == 'Default'
                                  ? AppColors.BLACK
                                  : AppColors.WHITE)),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 36),
                          child: FloatingActionButton(
                              heroTag: "RejectCall",
                              backgroundColor: AppColors.RED,
                              onPressed: () {
                                callController.rejectCall(
                                    context, callController.callSession);
                              },
                              child: const Icon(
                                Icons.call_end,
                                color: AppColors.WHITE,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 36),
                          child: FloatingActionButton(
                            heroTag: "AcceptCall",
                            backgroundColor: AppColors.GREEN,
                            onPressed: () {
                              callController.acceptCall(
                                  context, callController.callSession);
                            },
                            child: const Icon(
                              Icons.call,
                              color: AppColors.WHITE,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        })));
  }
}
