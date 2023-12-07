import 'package:get/get.dart';
import 'package:redis_studio/app/modules/log/binding.dart';
import 'package:redis_studio/app/modules/log/view.dart';
import 'package:redis_studio/app/modules/new_connection/binding.dart';
import 'package:redis_studio/app/modules/new_connection/view.dart';
import 'package:redis_studio/app/modules/settings/binding.dart';
import 'package:redis_studio/app/modules/settings/view.dart';

import '../modules/home/binding.dart';
import '../modules/home/view.dart';


class AppPages {

  static const HOME = '/home';
  static const SETTINGS = '/settings';
  static const NEW_CONNECTION = '/new_connection';
  static const LOG = '/log';

  static final routes = [
    GetPage(
      name: HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: SETTINGS,
      page: () => SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: NEW_CONNECTION,
      page: () => NewConnectionPage(),
      binding: NewConnectionBinding(),
    ),
    GetPage(
      name: LOG,
      page: () => LogPage(),
      binding: LogBinding(),
    ),
  ];
}
