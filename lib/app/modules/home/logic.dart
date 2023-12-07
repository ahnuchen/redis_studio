import 'package:get/get.dart';
import 'package:redis/redis.dart';
import 'package:redis_studio/app/data/local/my_shared_pref.dart';
import 'package:redis_studio/app/data/local/redis_connnect.dart';

import '../../../utils/redis_commands.dart';
import '../../data/models/connections_model.dart';

class HomeLogic extends GetxController {
  final _connect = Get.find<RedisConnect>();
  ConnectionsModel connectionsConfig = ConnectionsModel(connections: []);
  var splitPanelWeight = 0.2;
  List<String> expandKeys = [];
  List allKeys = [];

  Map<String, EnhanceCommand> commands = {};

  addConnectionConfig(ConnectionConfig cfg) {
    connectionsConfig.connections.add(
        cfg.copyWith(key: DateTime.timestamp().toString()));
    MySharedPref.saveConnections(connectionsConfig);
    update();
  }

  changeSplitPanelWights(double weights) {
    splitPanelWeight = weights;
    update();
  }

  scanAllKeys(EnhanceCommand command){
    command.scan(500).then((value) {
      allKeys = value[1];
      update();
    });
  }

  toggleExpandKey(ConnectionConfig cfg, bool isExpand) {
    var k = cfg.key!;
    if (!isExpand) {
      expandKeys.remove(k);
    } else {
      expandKeys.add(k);
      if (!commands.containsKey(k)) {
        _connect.createConnection(cfg).then((command) {
          var enhance = EnhanceCommand(command);
          commands[k] = enhance;
          scanAllKeys(enhance);
          update();
        });
      }
    }
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
    initLocalConnections();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }


}
