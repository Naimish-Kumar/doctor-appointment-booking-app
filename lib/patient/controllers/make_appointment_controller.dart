import 'dart:developer' as dev;

import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

import 'package:http/http.dart' as http;

import '../../common/utils/video_call_imports.dart';

class MakeAppointmentController extends GetxController {
  String id = Get.arguments['id'];
  String name = Get.arguments['name'];
  String consultationFee = Get.arguments['consultationFee'];

  DateTime dateTime = DateTime.now();

  RxBool isToday = true.obs;

  MakeAppointmentClass1? makeAppointmentClass;
  RxBool isLoading = true.obs;
  RxBool isLoading1 = true.obs;
  RxBool istimingSlotLoading = true.obs;
  RxBool isNoSlot = false.obs;
  RxBool isNoTimingSlot = false.obs;
  RxString description = "".obs;
  String userId = "";
  String doctorId = "";
  String date = "";
  RxString slotId = "".obs;
  RxString slotName = "".obs;
  RxBool isPhoneError = false.obs;
  ScrollController scrollController = ScrollController();
  RxBool isAppointmentMadeSuccessfully = false.obs;
  RxString AppointmentId = "".obs;
  TextEditingController textEditingController = TextEditingController();
  TextEditingController textEditingController1 = TextEditingController();

  Map<String, dynamic>? paymentIntent;

  List<String> days = [
    'day1'.tr,
    'day2'.tr,
    'day3'.tr,
    'day4'.tr,
    'day5'.tr,
    'day6'.tr,
    'day7'.tr,
    'day1'.tr,
  ];

  List<String> months = [
    'month1'.tr,
    'month2'.tr,
    'month3'.tr,
    'month4'.tr,
    'month5'.tr,
    'month6'.tr,
    'month7'.tr,
    'month8'.tr,
    'month9'.tr,
    'month10'.tr,
    'month11'.tr,
    'month12'.tr,
  ];

  List<RxBool> isSelected = <RxBool>[];
  RxList<RxBool> selectedSlot = <RxBool>[].obs;
  List<RxBool> selectedTimingSlot = <RxBool>[];
  RxInt previousSelectedIndex = 0.obs;
  RxInt previousSelectedSlot = 0.obs;
  RxInt previousSelectedTimingSlot = 0.obs;
  RxInt currentSlotsIndex = 0.obs;
  RxBool isDescriptionEmpty = false.obs;
  RxBool isChecked = true.obs;
  RxBool checkHolidayFuture = false.obs;

  initialize() async {
    for (int i = 0; i < 30; i++) {
      isSelected.add(false.obs);
    }
    isSelected[0].value = true;
    textEditingController.text =
        StorageService.readData(key: LocalStorageKeys.phone) ?? "";
    userId = StorageService.readData(key: LocalStorageKeys.userId) ?? "";
    doctorId = id;
    checkIfHoliday(
      dateTime.add(const Duration(days: 0)).toString().substring(0, 10),
      true,
      i: 0,
    );
  }

  initializeTimeSlots(int index) {
    selectedTimingSlot.clear();
    try {
      for (int i = 0;
          i < makeAppointmentClass!.data![index].slottime!.length;
          i++) {
        selectedTimingSlot.add(false.obs);
      }
    } catch (e) {
      isNoSlot.value = true;
      isLoading.value = false;
    }
    currentSlotsIndex.value = index;
  }

  processPayment({required BuildContext context}) async {
    Get.focusScope?.unfocus();
    if (slotId.value.isEmpty || slotId.value.length == 0) {
      messageDialog('error'.tr, 'select_appointment_time'.tr);
    } else if (textEditingController.text.isEmpty ||
        textEditingController.text.length < PHONE_LENGTH) {
      isPhoneError.value = true;
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    } else if (description.isEmpty) {
      isDescriptionEmpty.value = true;
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    } else {
      bottomSheet(context: context);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      customDialog(
        s1: 'success'.tr,
        s2: 'payment_success'.tr,
        dismiss: false,
        onPressed: () {
          Get.back();
          bookAppointment(type: "stripe", tId: paymentIntent!['id']);
          paymentIntent = null;
        },
      );
    } on StripeException catch (e) {
      customDialog(s1: 'fail'.tr, s2: "${'fail_description'.tr}\n$e");
    } catch (e) {
      customDialog(s1: 'fail'.tr, s2: "${'fail_description'.tr}\n$e");
    }
  }

  bookAppointment({
    String? tId,
    String? type,
  }) async {
    customDialog1(s1: 'reporting_dialog1'.tr, s2: 'appoint_make_dialog'.tr);

    String url = "${Apis.ServerAddress}/api/bookappointment";

    Map mm = {};

    if (type == 'stripe') {
      mm = {
        "user_id": userId,
        "doctor_id": doctorId,
        "date": date,
        "slot_id": slotId.value,
        "slot_name": slotName.value,
        "consultation_fees": consultationFee,
        "payment_type": type,
        "phone": textEditingController.text,
        "user_description": description.value,
        "stripe_payment_id": tId
      };
    } else {
      mm = {
        "user_id": userId,
        "doctor_id": doctorId,
        "date": date,
        "slot_id": slotId.value,
        "slot_name": slotName.value,
        "consultation_fees": consultationFee,
        "payment_type": type,
        "phone": textEditingController.text,
        "user_description": description.value,
      };
    }

    final response = await post(Uri.parse(url), body: mm);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse["success"].toString() == "1") {
        Get.back();
        AppointmentId.value = jsonResponse['data'].toString();
        if (type == 'online') {
          String? paymentLink;

          if (selectedPaymentMethod.value == 3) {
            paymentLink =
                '${Apis.ServerAddress}/paystack-payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 4) {
            paymentLink =
                '${Apis.ServerAddress}/rave-payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 5) {
            paymentLink =
                '${Apis.ServerAddress}/paytm-payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 6) {
            paymentLink =
                '${Apis.ServerAddress}/braintree_payment?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 7) {
            paymentLink =
                '${Apis.ServerAddress}/pay_razorpay?id=$AppointmentId&type=1';
          } else if (selectedPaymentMethod.value == 8) {
            paymentLink =
                '${Apis.ServerAddress}/stripe-payment?id=$AppointmentId&type=1';
          } else {
            messageDialog('fail'.tr, 'fail_description'.tr);
          }

          Get.toNamed(Routes.inAppWebViewScreen, arguments: {
            'url': paymentLink,
            'isDoctor': 1,
            'appointmentId': AppointmentId.value,
          })?.then((result) {
            if (result == 'success') {
              isAppointmentMadeSuccessfully.value = true;
              customDialog(
                s1: 'success'.tr,
                s2: 'appointment_made_success'.tr,
                dismiss: false,
                onPressed: () {
                  Get.back();
                  Get.back();
                  Get.back();
                  Get.toNamed(
                    Routes.uAppointmentDetailScreen,
                    arguments: {
                      'id': AppointmentId.value,
                    },
                  );
                },
              );
            } else if (result == 'fail') {
              messageDialog('fail'.tr, 'fail_description'.tr);
            }
          });
        } else if (type == 'stripe') {
          customDialog(
              s1: 'success'.tr,
              s2: 'appointment_made_success'.tr,
              onPressed: () {
                Get.back();
                Get.back();
                Get.back();
                Get.toNamed(
                  Routes.uAppointmentDetailScreen,
                  arguments: {
                    'id': AppointmentId.value,
                  },
                );
              },
              dismiss: false);
        } else {
          isAppointmentMadeSuccessfully.value = true;
          customDialog(
            dismiss: false,
            s1: 'success'.tr,
            s2: 'appointment_made_success'.tr,
            onPressed: () {
              Get.back();
              Get.back();
              Get.back();
              Get.toNamed(
                Routes.uAppointmentDetailScreen,
                arguments: {
                  'id': AppointmentId.value,
                },
              );
            },
          );
        }
      } else if (jsonResponse["success"].toString() == "3") {
        Get.back();
        customDialog(
          s1: 'error'.tr,
          s2: jsonResponse['register'],
          onPressed: () async {
            try {
              CallManager.instance.destroy();
              CubeChatConnection.instance.destroy();
              await PushNotificationsManager.instance.unsubscribe();
              await SharedPrefs.deleteUserData();
              await signOut();

              CubeChatConnection.instance.logout();
            } catch (e) {}
            await SharedPreferences.getInstance().then((pref) {
              pref.clear();
              pref.setString("isBack", "1");
            });
            StorageService.writeBoolData(
              key: LocalStorageKeys.isLoggedInAsDoctor,
              value: false,
            );
            StorageService.writeBoolData(
              key: LocalStorageKeys.isLoggedIn,
              value: false,
            );
            await Get.toNamed(Routes.loginUserScreen, arguments: {
              "isBack": false,
            });
          },
        );
      } else {
        Get.back();
        messageDialog('error'.tr, jsonResponse['register']);
      }
    }
  }

  checkIfHoliday(String date, bool isFirst, {required int i}) async {
    bool isHoliday = false;
    isLoading.value = true;
    isChecked.value = true;
    isNoSlot.value = false;

    var response = await http
        .get(Uri.parse(
            '${Apis.ServerAddress}/api/checkholiday?doctor_id=$doctorId&date=$date'))
        .catchError((e) {
      isNoSlot.value = true;
      isLoading.value = false;
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      isHoliday = jsonResponse['success'].toString() == '0' ? true : false;
      if (!isHoliday) {
        selectedSlot.clear();
        slotName.value = "";
        slotId.value = "";
        currentSlotsIndex.value = 0;
        previousSelectedTimingSlot.value = 0;
        makeAppointmentClass = MakeAppointmentClass1.fromJson(jsonResponse);
        if (makeAppointmentClass!.success.toString() == "1") {
          for (int i = 0; i < makeAppointmentClass!.data!.length; i++) {
            if (i == 0) {
              selectedSlot.add(true.obs);
            } else {
              selectedSlot.add(false.obs);
            }
          }
          initializeTimeSlots(0);
          isLoading.value = false;
          previousSelectedSlot.value = 0;
        } else {
          isNoSlot.value = true;
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
      }
    }
    checkHolidayFuture.value = isHoliday;
    isChecked.value = false;
    http.Client().close();
  }

  messageDialog(String s1, String s2) {
    customDialog(
      s1: s1,
      s2: s2,
      onPressed: () {
        Get.back();
      },
    );
  }

  RxInt selectedPaymentMethod = 2.obs;

  bottomSheet({required BuildContext context}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: AppColors.transparentColor,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.WHITE,
                      borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      15.hs,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: AppTextWidgets.boldTextWithColor(
                                text: name + "'s " + 'consultation_fee'.tr,
                                color: AppColors.BLACK,
                                size: 12,
                              ),
                            ),
                            20.ws,
                            AppTextWidgets.boldTextWithColor(
                              text: CURRENCY.trim() + (consultationFee),
                              color: AppColors.AMBER,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                      5.hs,
                      Divider(
                        color: AppColors.grey,
                        thickness: 0.7,
                      ),
                      5.hs,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AppTextWidgets.semiBoldText(
                          text: 'select_a_payment_method'.tr.toUpperCase(),
                          color: AppColors.LIGHT_GREY_TEXT,
                          size: 12,
                        ),
                      ),
                      5.hs,
                      Container(
                        height: Get.height * 0.5,
                        child: ListView(
                          children: [
                            paymentMethodCardTile(
                                title: 'method1_title'.tr,
                                explanation: 'method1_description'.tr,
                                index: 2,
                                setState: setState),
                            Divider(
                              color: AppColors.grey,
                              thickness: 0.7,
                            ),
                            paymentMethodCardTile(
                                title: 'method2_title'.tr,
                                explanation: 'common_description'.tr,
                                index: 3,
                                setState: setState),
                            Divider(
                              color: AppColors.grey,
                              thickness: 0.7,
                            ),
                            paymentMethodCardTile(
                                title: 'method3_title'.tr,
                                explanation: 'common_description'.tr,
                                index: 4,
                                setState: setState),
                            Divider(
                              color: AppColors.grey,
                              thickness: 0.7,
                            ),
                            // paymentMethodCardTile(
                            //     title: 'method4_title'.tr,
                            //     explanation: 'common_description'.tr,
                            //     index: 5,
                            //     setState: setState),
                            // Divider(
                            //   color: AppColors.grey,
                            //   thickness: 0.7,
                            // ),
                            paymentMethodCardTile(
                                title: 'method5_title'.tr,
                                explanation: 'common_description'.tr,
                                index: 6,
                                setState: setState),
                            Divider(
                              color: AppColors.grey,
                              thickness: 0.7,
                            ),
                            paymentMethodCardTile(
                                title: 'method7_title'.tr,
                                explanation: 'common_description'.tr,
                                index: 7,
                                setState: setState),
                            Divider(
                              color: AppColors.grey,
                              thickness: 0.7,
                            ),
                            paymentMethodCardTile(
                                title: 'method6_title'.tr,
                                explanation: 'method6_description'.tr,
                                index: 8,
                                setState: setState),
                            Divider(
                              color: AppColors.grey,
                              thickness: 0.7,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => CustomButton(
                    onTap: () async {
                      Get.back();
                      if (selectedPaymentMethod.value == 2) {
                        bookAppointment(type: "COD");
                      } else if (selectedPaymentMethod.value == 8) {
                        paymentIntent =
                            await (String amount, String currency) async {
                          Map<String, dynamic> body = {
                            'amount': ((int.parse(amount)) * 100).toString(),
                            'currency': currency,
                            'payment_method_types[]': 'card',
                          };

                          var response = await http.post(
                            Uri.parse(
                                'https://api.stripe.com/v1/payment_intents'),
                            headers: {
                              'Authorization': 'Bearer $stripeSecretKey',
                              'Content-Type':
                                  'application/x-www-form-urlencoded'
                            },
                            body: body,
                          );
                          return jsonDecode(response.body.toString());
                        }(consultationFee, CURRENCY_CODE);
                        http.Client().close();
                        await Stripe.instance.initPaymentSheet(
                          paymentSheetParameters: SetupPaymentSheetParameters(
                            paymentIntentClientSecret:
                                paymentIntent!['client_secret'],
                            merchantDisplayName: 'Doctor Finder',
                          ),
                        );
                        displayPaymentSheet();
                      } else {
                        bookAppointment(
                          type: "online",
                        );
                      }
                    },
                    btnText: selectedPaymentMethod.value == 2
                        ? 'make_an_appointment'.tr
                        : 'process_payment'.tr,
                  ),
                )
              ],
            );
          });
        });
  }

  paymentMethodCardTile(
          {required String title,
          required String explanation,
          required int index,
          required StateSetter setState}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: InkWell(
          onTap: () {
            setState(() {
              selectedPaymentMethod.value = index;
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.LIGHT_GREY_TEXT),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: selectedPaymentMethod.value == index
                        ? AppColors.AMBER
                        : AppColors.transparentColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidgets.mediumTextWithSize(
                      text: title,
                      size: 18,
                    ),
                    AppTextWidgets.blackText(
                      text: explanation,
                      color: AppColors.LIGHT_GREY_TEXT,
                      size: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initialize();
    date = dateTime.toString().substring(0, 10);
  }
}
