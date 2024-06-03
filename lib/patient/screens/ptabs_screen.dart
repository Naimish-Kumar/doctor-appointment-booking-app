import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';
import 'package:videocalling/patient/utils/patient_imports.dart';

class PatientTabsScreen extends GetView<PatientTabController> {
  const PatientTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PatientTabController tabController = Get.put(PatientTabController());
    return Scaffold(
      body: Obx(() => tabController.getPage(tabController.index.value)),
      bottomNavigationBar: Obx(() => Container(
            decoration: BoxDecoration(
              color: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(15)),
              child: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 0
                          ? AppImages.tab1Select
                          : AppImages.tab1Unselect,
                      height: 25,
                      width: 25,
                    ),
                    label: 'home'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 1
                          ? AppImages.tab2Select
                          : AppImages.tab2Unselect,
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                    label: 'appointment'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 2
                          ? AppImages.tab3uSelect
                          : AppImages.tab3uUnselect,
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                    label: 'doctor_login'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 3
                          ? AppImages.tab4Select
                          : AppImages.tab4Unselect,
                      height: 25,
                      width: 25,
                      // fit: BoxFit.cover,
                    ),
                    label: 'recent_chats'.tr,
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset(
                      tabController.index.value == 4
                          ? AppImages.tab5Select
                          : AppImages.tab5Unselect,
                      height: 25,
                      width: 25,
                      fit: BoxFit.cover,
                    ),
                    label: 'more'.tr,
                  ),
                ],
                selectedLabelStyle: const TextStyle(
                  color: AppColors.BLACK,
                  fontFamily: AppFontStyleTextStrings.regular,
                  fontSize: 8,
                ),
                type: BottomNavigationBarType.fixed,
                unselectedLabelStyle: const TextStyle(
                  fontFamily: AppFontStyleTextStrings.regular,
                  color: AppColors.BLACK,
                  fontSize: 7,
                ),
                unselectedItemColor: AppColors.LIGHT_GREY_TEXT,
                selectedItemColor: AppColors.BLACK,
                onTap: (i) {
                  if (i == 0) {
                    Get.lazyPut<UserHomeController>(
                      () => UserHomeController(),
                    );
                  } else if (i == 1) {
                    Get.lazyPut<UserPastAppointmentsController>(
                      () => UserPastAppointmentsController(),
                    );
                  } else if (i == 2) {
                    Get.lazyPut<DoctorLoginController>(
                      () => DoctorLoginController(),
                    );
                  } else if (i == 3) {
                    Get.lazyPut<PatientChatListController>(
                      () => PatientChatListController(),
                    );
                  } else if (i == 4) {
                    Get.lazyPut<PatientMoreScreenController>(
                      () => PatientMoreScreenController(),
                    );
                  }
                  if (tabController.index.value == 0) {
                    Get.delete<UserHomeController>();
                  } else if (tabController.index.value == 3) {
                    Get.delete<PatientChatListController>();
                  } else if (tabController.index.value == 1) {
                    Get.delete<UserPastAppointmentsController>();
                  } else if (tabController.index.value == 2) {
                    Get.delete<DoctorLoginController>();
                  } else if (tabController.index.value == 4) {
                    Get.delete<PatientMoreScreenController>();
                  }

                  tabController.index.value = i;
                },
                currentIndex: tabController.index.value,
              ),
            ),
          )),
    );
  }
}
