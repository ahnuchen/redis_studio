import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redis_studio/config/translations/strings_enum.dart';
import 'package:split_view/split_view.dart';
import '../../routes/app_pages.dart';

import 'logic.dart';

class HomePage extends GetView<HomeLogic> {
  HomePage() {
    print('Enter Home Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<HomeLogic>(builder: (logic) {
      return SplitView(
        gripColor: Get.theme.highlightColor,
        viewMode: SplitViewMode.Horizontal,
        indicator: SplitIndicator(
          viewMode: SplitViewMode.Horizontal,
          color: Get.theme.disabledColor,
        ),
        activeIndicator: SplitIndicator(
          viewMode: SplitViewMode.Horizontal,
          isActive: true,
        ),
        onWeightChanged: (weights) {
          controller.changeSplitPanelWights(weights[0]!);
        },
        controller: SplitViewController(
            limits: [WeightLimit(min: 0.2, max: 0.6), null],
            weights: [controller.splitPanelWeight]),
        children: [
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    OutlinedButton(
                        onPressed: () {
                          Get.toNamed(AppPages.NEW_CONNECTION);
                        },
                        child: Text(Strings.new_connection.tr)),
                    Row(
                      children: <Widget>[
                        IconButton(
                          color: Get.theme.primaryColor,
                          onPressed: () {
                            Get.toNamed(AppPages.SETTINGS);
                          },
                          icon: Icon(Icons.settings),
                          tooltip: Strings.settings,
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: ExpansionPanelList(
                    expansionCallback: (index, expand) {
                      controller.toggleExpandKey(
                          controller.connectionsConfig.connections[index],
                          expand);
                    },
                    children: controller.connectionsConfig.connections
                        .map((cfg) => ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: controller.expandKeys.contains(cfg.key),
                            headerBuilder: (context, isOpen) {
                              return ListTile(
                                mouseCursor: MouseCursor.defer,
                                title: Text(cfg.name ??
                                    ('${cfg.host}:${cfg.port}(${cfg.key?.substring(cfg.key!.length - 3, cfg.key!.length)})')),
                              );
                            },
                            body: ListView.builder(
                              itemBuilder: (context, index) {
                                return Text(controller.allKeys[index]);
                              },
                              itemCount: controller.allKeys.length,
                              shrinkWrap: true,
                            )))
                        .toList(),
                  ),
                ))
              ],
            ),
          ),
          Container(),
        ],
      );
    }));
  }
}
