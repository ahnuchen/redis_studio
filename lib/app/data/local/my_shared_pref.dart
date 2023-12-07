import 'package:flutter/material.dart';
import 'package:redis_studio/app/data/models/connections_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/translations/localization_service.dart';

class MySharedPref {
  // prevent making instance
  MySharedPref._();

  // get storage
  static late SharedPreferences _sharedPreferences;

  // STORING KEYS
  static const String _currentLocalKey = 'current_local';
  static const String _lightThemeKey = 'is_theme_light';
  static const String _fontScaleKey = 'current_font_scale';
  static const String _connectionsKey = 'saved_connections';

  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  static String? getStorage(String key) {
    return _sharedPreferences.getString(key);
  }
  static String? getCurrentLocaleString() {
    return _sharedPreferences.getString(_currentLocalKey);
  }

  /// set theme current type as light theme
  static Future<void> setThemeIsLight(bool lightTheme) =>
      _sharedPreferences.setBool(_lightThemeKey, lightTheme);

  /// get if the current theme type is light
  static bool getThemeIsLight() =>
      _sharedPreferences.getBool(_lightThemeKey) ?? true; // todo set the default theme (true for light, false for dark)

  /// save current locale
  static Future<void> setCurrentLanguage(String languageCode) =>
      _sharedPreferences.setString(_currentLocalKey, languageCode);

  /// get current locale
  static Locale getCurrentLocal(){
      String? langCode = _sharedPreferences.getString(_currentLocalKey);
      // default language is english
      if(langCode == null){
        return LocalizationService.defaultLanguage;
      }
      return LocalizationService.supportedLanguages[langCode]!;
  }

  static setFontScale(scale) => _sharedPreferences.setDouble(_fontScaleKey, scale);

  static getFontScale() => _sharedPreferences.getDouble(_fontScaleKey) ?? 1.0;

  static saveConnections(ConnectionsModel connectionsModel){
    _sharedPreferences.setString(_connectionsKey, connectionsModel.toRawJson());
  }

  static ConnectionsModel getSavedConnections(){
    var str = _sharedPreferences.getString(_connectionsKey);
    if(str == null){
      return ConnectionsModel(connections: []);
    } else {
      return ConnectionsModel.fromRawJson(str);
    }
  }


  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences.clear();

}