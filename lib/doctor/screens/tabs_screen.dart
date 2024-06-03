import 'package:videocalling/common/utils/app_imports.dart';
import 'package:videocalling/doctor/utils/doctor_imports.dart';

class DoctorTabsScreen extends GetView<DoctorTabController> {
  const DoctorTabsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DoctorTabController tabController = Get.put(DoctorTabController());
    return WillPopScope(
      onWillPop: tabController.willPopScope,
      child: Scaffold(
        body: Obx(() => tabController.getPage(tabController.index.value)),
        bottomNavigationBar: Obx(() => Container(
              decoration: BoxDecoration(
                color: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15)),
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
                            ? AppImages.tab3dSelect
                            : AppImages.tab3dUnselect,
                        height: 25,
                        width: 25,
                        fit: BoxFit.cover,
                      ),
                      label: 'edit_profile'.tr,
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        tabController.index.value == 3
                            ? AppImages.tab4Select
                            : AppImages.tab4Unselect,
                        height: 25,
                        width: 35,
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
                  selectedLabelStyle: TextStyle(
                    color: AppColors.BLACK,
                    fontSize: 8,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                  type: BottomNavigationBarType.fixed,
                  unselectedLabelStyle: TextStyle(
                    color: AppColors.BLACK,
                    fontSize: 7,
                    fontFamily: AppFontStyleTextStrings.regular,
                  ),
                  unselectedItemColor: AppColors.LIGHT_GREY_TEXT,
                  selectedItemColor: AppColors.BLACK,
                  onTap: (i) {
                    if (tabController.index.value == i) return;
                    if (i == 0) {
                      Get.lazyPut<DoctorDashboardController>(
                        () => DoctorDashboardController(),
                      );
                    } else if (i == 1) {
                      Get.lazyPut<DoctorPastAppointmentsController>(
                        () => DoctorPastAppointmentsController(),
                      );
                    } else if (i == 2) {
                      Get.lazyPut<DoctorProfileController>(
                        () => DoctorProfileController(),
                      );
                    } else if (i == 3) {
                      Get.lazyPut<DMoreInfoController>(
                        () => DMoreInfoController(),
                      );
                    } else if (i == 4) {
                      Get.lazyPut<DoctorChatListController>(
                        () => DoctorChatListController(),
                      );
                    }

                    if (tabController.index.value == 0) {
                      Get.delete<DoctorDashboardController>();
                    } else if (tabController.index.value == 1) {
                      Get.delete<DoctorPastAppointmentsController>();
                    } else if (tabController.index.value == 2) {
                      Get.delete<DoctorProfileController>();
                    } else if (tabController.index.value == 4) {
                      Get.delete<DMoreInfoController>();
                    } else if (tabController.index.value == 3) {
                      Get.delete<DoctorChatListController>();
                    }

                    tabController.index.value = i;
                    tabController.update();
                  },
                  currentIndex: tabController.index.value,
                ),
              ),
            )),
      ),
    );
  }
}
