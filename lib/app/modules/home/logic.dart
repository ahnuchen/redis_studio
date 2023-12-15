import 'package:get/get.dart';

import '../../../utils/redis_commands.dart';

class HomeLogic extends GetxController {
  var splitPanelWeight = 0.2;


  changeSplitPanelWights(double weights) {
    splitPanelWeight = weights;
    update();
  }

  @override
  void onInit() async {
    //
    // var connection = await _connect.createConnection();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
