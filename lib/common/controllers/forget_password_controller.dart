import 'package:videocalling/common/utils/app_imports.dart';

class ForgetPasswordController extends GetxController {
  String id = Get.arguments['id'];

  TextEditingController emailTextField = TextEditingController();
  RxBool isEmailError = false.obs;
  RxString emailError = "".obs;

  sendEmail() async {
    customDialog1(s1: 'loading'.tr, s2: 'please_wait_while_processing'.tr);
    final response = await get(Uri.parse(
            "${Apis.ServerAddress}/api/forgotpassword?type=$id&email=${emailTextField.text}"))
        .timeout(const Duration(seconds: Apis.timeOut))
        .catchError((e) {
      Get.back();
      messageDialog('error', e.toString(), 0);
    });

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['success'] == 1) {
      final jsonResponse = jsonDecode(response.body);
      Get.back();
      messageDialog('success'.tr, jsonResponse['msg'], 1);
    } else {
      Get.back();
      messageDialog('error'.tr, jsonDecode(response.body)['msg'], 0);
    }
    Client().close();
  }

  messageDialog(String s1, String s2, int i) {
    customDialog(
        s1: s1,
        s2: s2,
        onPressed: () async {
          if (i == 1 && id == "1") {
            Get.back();
            Get.back();
          } else if (i == 1 && id == "2") {
            Get.back();
            Get.back();
          } else {
            Get.back();
          }
        },
        s3style: const TextStyle(
          fontFamily: AppFontStyleTextStrings.medium,
          color: AppColors.BLACK,
        ));
  }
}
