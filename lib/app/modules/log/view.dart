import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class LogPage extends StatelessWidget {
  final logic = Get.find<LogLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('log'),
        ),
        body: Placeholder());
  }
}
