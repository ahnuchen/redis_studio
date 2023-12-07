import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:redis_studio/app/data/models/connections_model.dart';
import 'package:redis_studio/app/modules/home/logic.dart';

class NewConnectionLogic extends GetxController {
  final homeLogic = Get.find<HomeLogic>();

  TextEditingController hostInputController = TextEditingController();
  TextEditingController portInputController = TextEditingController();
  TextEditingController pwdInputController = TextEditingController();
  TextEditingController usernameInputController = TextEditingController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController separateInputController = TextEditingController();

  saveConnection() {
    var host = hostInputController.text;
    var port = portInputController.text;
    var name = nameInputController.text;
    ConnectionConfig cfg = ConnectionConfig(
        host: host == '' ? 'localhost' : host,
        name: name,
        port: port == '' ? 6379 : int.tryParse(port));
    print('cfg:');
    print(cfg.toRawJson());
    homeLogic.addConnectionConfig(cfg);
    Get.back();
  }

  initInputValue() {
    separateInputController.text = ':';
  }

  @override
  void onInit() {
    // TODO: implement onInit
    initInputValue();

    super.onInit();
  }
}
