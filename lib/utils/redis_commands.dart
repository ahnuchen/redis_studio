import 'package:redis/redis.dart';

class EnhanceCommand {

  Command command;

  EnhanceCommand(this.command);

  Future getInfo() => command.send_object(['INFO']);

  // scan 0 MATCH * COUNT 500
  Future scan(count) => command.send_object(['SCAN', '0', 'COUNT', count.toString()]);
}