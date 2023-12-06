import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'app/data/local/my_shared_pref.dart';
import 'app/routes/app_pages.dart';
import 'config/theme/my_theme.dart';
import 'config/translations/localization_service.dart';

Future<void> main() async {
  // wait for bindings
  WidgetsFlutterBinding.ensureInitialized();


  // init shared preference
  await MySharedPref.init();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "redis_studio",
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      builder: (context, widget) {
        bool themeIsLight = MySharedPref.getThemeIsLight();
        return Theme(
          data: MyTheme.getThemeData(isLight: themeIsLight),
          child: MediaQuery(
            // prevent font from scalling (some people use big/small device fonts)
            // but we want our app font to still the same and dont get affected
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: widget!,
          ),
        );
      },
      initialRoute: AppPages.INITIAL,
      // first screen to show when app is running
      getPages: AppPages.routes,
      // app screens
      locale: MySharedPref.getCurrentLocal(),
      // app language
      translations: LocalizationService
          .getInstance(), // localization services in app (controller app language)
    );
  }
}