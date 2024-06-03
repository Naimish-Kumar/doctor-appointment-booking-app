import 'package:videocalling/common/utils/app_imports.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAppController());
    return GetMaterialApp(
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(
        milliseconds: 500,
      ),
      translations: Words(),
      locale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        timePickerTheme: TimePickerThemeData(
          dayPeriodTextColor: AppColors.themeColor1,
          helpTextStyle: const TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
        ),
        hintColor: AppColors.themeColor1,
        primaryColor: AppColors.themeColor2,
        backgroundColor: AppColors.WHITE,
        primaryColorDark: AppColors.themeColor3,
        primaryColorLight: AppColors.LIGHT_GREY_SCREEN_BACKGROUND,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          headline2: TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          headline3: TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          headline4: TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          headline5: TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          headline6: TextStyle(
            fontFamily: AppFontStyleTextStrings.medium,
          ),
          subtitle1: TextStyle(
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          subtitle2: TextStyle(
            fontFamily: AppFontStyleTextStrings.medium,
          ),
          caption: TextStyle(
            fontSize: 10,
            fontFamily: AppFontStyleTextStrings.regular,
          ),
          bodyText1: TextStyle(
            fontSize: 13,
            fontFamily: AppFontStyleTextStrings.medium,
          ),
          bodyText2: TextStyle(
            fontSize: 13,
            fontFamily: AppFontStyleTextStrings.light,
          ),
          button: TextStyle(
            fontFamily: AppFontStyleTextStrings.medium,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('he', ''),
        Locale('ar', ''),
        Locale.fromSubtags(languageCode: 'zh'),
      ],
    );
  }
}
