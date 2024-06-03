import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class LoginAsDoctor extends GetView<DoctorLoginController> {
  final DoctorLoginController doctorLoginController =
      Get.put(DoctorLoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: CustomAppBar(
          title: 'doctor_login'.tr,
        ),
        leading: Container(),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.WHITE,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: const Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      children: [
                        Image.asset(
                          AppImages.loginDoctor,
                          height: 180,
                          width: 180,
                        ),
                        const SizedBox(height: 20),
                        Obx(() => EditTextField(
                              keyboardType: TextInputType.emailAddress,
                              editingController: doctorLoginController.email,
                              labelText: 'enter_email_hint'.tr,
                              errorText:
                                  doctorLoginController.isPhoneNumberError.value
                                      ? 'enter_email_error'.tr
                                      : null,
                              onChanged: (val) {
                                doctorLoginController.emailAddress.value = val;
                                doctorLoginController.isPhoneNumberError.value =
                                    false;
                                doctorLoginController.isPasswordError.value =
                                    false;
                              },
                            )),
                        const SizedBox(height: 10),
                        Obx(() => EditTextField(
                              obscureText: true,
                              keyboardType: TextInputType.visiblePassword,
                              editingController: doctorLoginController.password,
                              labelText: 'password'.tr,
                              errorText: doctorLoginController
                                      .isPasswordError.value
                                  ? doctorLoginController.passErrorText.value
                                  : null,
                              onChanged: (val) {
                                doctorLoginController.pass.value = val;
                                doctorLoginController.isPasswordError.value =
                                    false;
                              },
                            )),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                await Get.toNamed(
                                  Routes.forgetPasswordScreen,
                                  arguments: {
                                    "id": "2",
                                  },
                                );
                                Get.delete<ForgetPasswordController>();
                              },
                              child: AppTextWidgets.boldTextWithColor(
                                text: 'forget_password'.tr,
                                color: AppColors.BLACK,
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                            height: 50,
                            child: InkWell(
                              onTap: () {
                                Get.focusScope?.unfocus();
                                doctorLoginController.loginInto();
                              },
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppColors.color1,
                                            AppColors.color2,
                                          ],
                                          begin: Alignment.bottomLeft,
                                          end: Alignment.topRight,
                                        ),
                                      ),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                  ),
                                  Center(
                                    child: AppTextWidgets.mediumText(
                                      text: 'login'.tr,
                                      color: AppColors.WHITE,
                                      size: 18,
                                    ),
                                  )
                                ],
                              ),
                            )),
                        const SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppTextWidgets.mediumText(
                                    text: 'not_have_an_account'.tr,
                                    size: 12,
                                    color: AppColors.BLACK),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.doctorRegisterScreen);
                                  },
                                  child: AppTextWidgets.mediumText(
                                    text: "register_now".tr,
                                    color: AppColors.AMBER,
                                    size: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
