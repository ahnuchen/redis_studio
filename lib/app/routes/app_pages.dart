import 'package:get/get.dart';
import 'package:redis_studio/app/modules/context_menu/view.dart';
import 'package:redis_studio/app/modules/expandable_list/view.dart';
import 'package:redis_studio/app/modules/flutter_tree_view_custom/view.dart';
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
  static const CONTEXTMENU = '/context_menu';
  static const FLUTTER_TREE_VIEW_CUSTOM = '/flutter_tree_view_custom';
  static const EXPANDABLE_LIST = '/expandable_list';

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
    GetPage(
      name: CONTEXTMENU,
      page: () => ContextMenuPage(),
    ),
    GetPage(
      name: FLUTTER_TREE_VIEW_CUSTOM,
      page: () => FlutterTreeViewPage(),
    ),
    GetPage(
      name: EXPANDABLE_LIST,
      page: () => ExpandableListPage(),
    ),

  ];
}
