import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    CubeSettings.instance.isDebugEnabled = false;
    Get.isLogEnable = false;
    getToken();
  }

  getToken() async {
    getCC();

    Timer(Duration(seconds: 2), () {
      if (StorageService.readData(key: LocalStorageKeys.isLoggedInAsDoctor) ??
          false) {
        Get.offAllNamed(Routes.doctorTabScreen);
      } else if (StorageService.readData(key: LocalStorageKeys.isLoggedIn) ??
          false) {
        Get.offAllNamed(Routes.userTabScreen);
      } else {
        Get.offAllNamed(Routes.userTabScreen);
      }
    });
  }

  getCC() {
    SharedPrefs.getUser().then((value) {
      if (value == null) return;
      ConnectyCubeSessionService.loginToCC(
        value,
        onTap: () => changeNotifier.updateString("Done"),
      );
    });
  }
}
