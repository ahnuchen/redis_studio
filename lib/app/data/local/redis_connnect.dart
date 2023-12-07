import 'package:redis/redis.dart';
import 'package:redis_studio/app/data/models/connections_model.dart';

class RedisConnect {

  RedisConnect(){
    print('create redis connect');
  }

  final conn = RedisConnection();

  Future<Command> createConnection(ConnectionConfig cfg) async {
    return await conn.connect(cfg.host, cfg.port);
  }
}
