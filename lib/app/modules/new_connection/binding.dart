import 'package:get/get.dart';

import 'logic.dart';

class NewConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewConnectionLogic());
  }
}
