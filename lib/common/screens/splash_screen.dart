import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/main.dart';

class SplashScreen extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: AppColors.WHITE,
      body: Stack(
        children: [
          Image.asset(
            AppImages.splashBg,
            fit: BoxFit.fill,
            height: Get.height,
            width: Get.width,
          ),
          Padding(
            padding: const EdgeInsets.all(85),
            child: Center(
              child: Image.asset(
                AppImages.splashIcon,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}