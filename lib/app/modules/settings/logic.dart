import 'package:get/get.dart';
import 'package:redis_studio/app/data/local/my_shared_pref.dart';
import 'package:redis_studio/app/data/local/redis_connnect.dart';

class SettingsLogic extends GetxController {
  bool themeIsLight = false;
  String localeKey = 'zh';
  double textScale = 1;

  toggleTheme() {
    themeIsLight = !themeIsLight;
    update();
  }

  toggleLang(k) {
    localeKey = k;
    MySharedPref.setCurrentLanguage(k);
    update();
  }
  setFontScale(v) {
    textScale = v / 10;
    MySharedPref.setFontScale(v/10);
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    print('Settings onInit');

    localeKey = MySharedPref.getCurrentLocaleString() ?? 'zh';
    themeIsLight = MySharedPref.getThemeIsLight();
    textScale = MySharedPref.getFontScale();
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    print('Settings onReady');
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    print('Settings onClose');
    super.onClose();
  }
}
