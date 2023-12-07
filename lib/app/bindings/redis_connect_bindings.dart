import 'package:get/get.dart';
import '../data/local/redis_connnect.dart';

class RedisConnectBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RedisConnect());
  }
}
