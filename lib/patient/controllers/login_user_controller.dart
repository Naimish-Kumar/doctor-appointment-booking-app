import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/common/utils/video_call_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class UserLoginController extends GetxController {
  bool isBack = Get.arguments['isBack'];
  RxString phoneNumber = "".obs;
  RxString pass = "".obs;
  RxBool isPhoneNumberError = false.obs;
  RxBool isPasswordError = false.obs;
  RxString passErrorText = "".obs;
  RxString token = "".obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  RxString name = "".obs, email = "".obs, image = "".obs;
  String message = "";

  TextEditingController emailT = TextEditingController();
  TextEditingController passwordT = TextEditingController();

  storeToken(type) async {
    customDialog1(
      s1: 'login_dialog_title'.tr,
      s2: 'login_dialog_description'.tr,
      s1style: Theme.of(Get.context!).textTheme.bodyMedium,
      s2style: Theme.of(Get.context!).textTheme.bodyMedium,
    );
    if (token.value.isEmpty) {
      await getToken();
    }
    final response =
        await post(Uri.parse("${Apis.ServerAddress}/api/savetoken"), body: {
      "token": token.value,
      "type": "1",
    }).catchError((e) {
      messageDialog('error'.tr, 'unable_to_save_token'.tr);
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        StorageService.writeBoolData(
          key: LocalStorageKeys.isTokenExist,
          value: true,
        );
        StorageService.writeStringData(
          key: LocalStorageKeys.token,
          value: token.value,
        );
        Get.back();
        loginInto(type);
      } else {
        Get.back();
        messageDialog('error'.tr, "${jsonResponse['register']}");
      }
    } else {
      Get.back();
      messageDialog('error'.tr, response.body.toString());
    }
  }

  getToken() async {
    if (StorageService.readData(key: LocalStorageKeys.isTokenExist) == null) {
      firebaseMessaging.getToken().then((value) {
        if (value == null) return;
        token.value = value;
      }).catchError((e) {
        messageDialog('error'.tr, 'unable_to_save_token'.tr);
      });
    } else {
      token.value = StorageService.readData(key: LocalStorageKeys.token);
    }
  }

  loginInto(int type) async {
    if (GetUtils.isEmail(phoneNumber.value) == false && type == 1) {
      isPhoneNumberError.value = true;
    } else if ((pass.value.length < PASS_LENGTH) && type == 1) {
      isPasswordError.value = true;
      passErrorText.value = 'enter_6_characters'.tr;
    } else if (StorageService.readData(key: LocalStorageKeys.isTokenExist) ==
        null) {
      storeToken(type);
    } else {
      customDialog1(
        s1: 'login_dialog_title'.tr,
        s2: 'login_dialog_description'.tr,
        s1style: Theme.of(Get.context!).textTheme.bodyLarge,
        s2style: Theme.of(Get.context!).textTheme.bodyMedium,
      );

      String url = type == 1
          ? "${Apis.ServerAddress}/api/login?email=${phoneNumber.value}&password=${pass.value}&login_type=$type&token=${token.value}"
          : "${Apis.ServerAddress}/api/login?email=${email.value}&login_type=$type&token=${token.value}&name=${name.value}";

      var response = await post(Uri.parse(url)).catchError((e) {
        Get.back();
        messageDialog('error'.tr, 'unable_to_load_data'.tr);
      });

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['success'].toString() == "0") {
          Get.back();
          if (type != 1) {
            errorDialog(message: jsonDecode(response.body)['register']);
          } else {
            isPasswordError.value = true;
            passErrorText.value = 'either_email_password_incorrect'.tr;
          }
        } else {
          UserLoginResponse _response =
              UserLoginResponse.fromJson(jsonDecode(response.body));
          FirebaseDatabase.instance
              .ref()
              .child("117${_response.register!.userId}")
              .update({
            "name": _response.register!.name,
            "image": _response.register!.profilePic,
          }).then((value) async {
            FirebaseDatabase.instance
                .ref()
                .child("117${_response.register!.userId}")
                .child("TokenList")
                .set({
              "device": token.value,
            }).then((value) async {
              StorageService.writeBoolData(
                key: LocalStorageKeys.isLoggedIn,
                value: true,
              );
              StorageService.writeStringData(
                  key: LocalStorageKeys.phone,
                  value: _response.register!.phone == null
                      ? ""
                      : _response.register!.phone.toString());
              StorageService.writeStringData(
                  key: LocalStorageKeys.password, value: pass.value);
              StorageService.writeStringData(
                  key: LocalStorageKeys.name,
                  value: _response.register!.name ?? "");
              StorageService.writeStringData(
                  key: LocalStorageKeys.email,
                  value: _response.register!.email!);
              StorageService.writeStringData(
                  key: LocalStorageKeys.userIdWithAscii,
                  value: ('117${_response.register!.userId}'));
              StorageService.writeStringData(
                  key: LocalStorageKeys.callerImage,
                  value: _response.register!.profilePic!);
              StorageService.writeStringData(
                  key: LocalStorageKeys.userId,
                  value: _response.register!.userId.toString());
              StorageService.writeStringData(
                  key: LocalStorageKeys.profileImage,
                  value: _response.register!.profilePic!);
              CubeUser user = CubeUser(
                id: _response.register?.connectycubeUserId,
                login: _response.register?.loginId,
                fullName:
                    _response.register?.name.toString().replaceAll(" ", ""),
                password: type == 2
                    ? _response.register?.connectycubePassword.toString()
                    : _response.register?.connectycubePassword.toString(),
              );
              ConnectyCubeSessionService.loginToCC(
                user,
                onTap: () {
                  if (isBack) {
                    Get.back();
                    Get.back(result: true);
                    changeNotifier.updateString("Done");
                  } else {
                    Get.offAllNamed(Routes.userTabScreen);
                    changeNotifier.updateString("Done");
                  }
                },
              );
            });
          });
        }
      }
    }
  }

  messageDialog(String s1, String s2) {
    customDialog(
      s1: s1,
      s2: s2,
      s1style: Theme.of(Get.context!).textTheme.bodyLarge,
      s2style: Theme.of(Get.context!).textTheme.bodyLarge,
      s3style: Theme.of(Get.context!).textTheme.bodyLarge,
    );
  }

  googleLogin() async {
    await _googleSignIn.signIn().then((value) {
      if (value != null) {
        name.value = value.displayName ?? "";
        email.value = value.email;
        image.value = value.photoUrl ?? "";
        loginInto(2);
      }
    }).catchError((e) {
      errorDialog(message: e.toString());
    });
  }

  TextEditingController MobileNumber = TextEditingController();
  bool isMobileNumberError = false;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getToken();
  }
}
