import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redis_studio/app/modules/home/components/connection_item/view.dart';

import 'logic.dart';

class ConnectionsComponent extends StatelessWidget {
  final logic = Get.put(ConnectionsLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      height: context.height - 70,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          var cfg = logic.connectionsConfig.connections[index];
          return ConnectionItemComponent(cfg: cfg, key: Key(cfg.key!));
        },
        itemCount: logic.connectionsConfig.connections.length,
      ),
    );
  }
}
