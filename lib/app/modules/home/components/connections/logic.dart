import 'package:get/get.dart';

import '../../../../data/local/my_shared_pref.dart';
import '../../../../data/models/connections_model.dart';

class ConnectionsLogic extends GetxController {
  ConnectionsModel connectionsConfig = ConnectionsModel(connections: []);

  addConnectionConfig(ConnectionConfig cfg) {
    connectionsConfig.connections
        .add(cfg.copyWith(key: DateTime.timestamp().toString()));
    MySharedPref.saveConnections(connectionsConfig);
    update();
  }

  initLocalConnections() {
    connectionsConfig = MySharedPref.getSavedConnections();
    update();
  }

  @override
  void onInit() async {
    //
    // var connection = await _connect.createConnection();
    super.onInit();
  }
  @override
  void onReady() {
    initLocalConnections();
    super.onReady();
  }

}
