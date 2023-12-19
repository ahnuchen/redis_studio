import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redis_studio/app/modules/home/components/connections/view.dart';
import 'package:redis_studio/config/translations/strings_enum.dart';
import 'package:split_view/split_view.dart';
import '../../routes/app_pages.dart';

import 'components/tabs/view.dart';
import 'logic.dart';

class HomePage extends GetView<HomeLogic> {
  HomePage() {
    print('Enter Home Page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<HomeLogic>(builder: (logic) {
      return ContextMenuOverlay(
        child: SplitView(
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
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(
                          child: OutlinedButton.icon(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                Get.toNamed(AppPages.NEW_CONNECTION);
                              },
                              label: Text(Strings.new_connection.tr)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Get.toNamed(AppPages.SETTINGS);
                            },
                            icon: Icon(Icons.settings),
                            tooltip: Strings.settings,
                          ),
                          IconButton(
                            onPressed: () {
                              Get.toNamed(AppPages.LOG);
                            },
                            icon: Icon(Icons.history),
                            tooltip: Strings.command_log,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ConnectionsComponent(),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(
                    width: context.width - context.width * controller.splitPanelWeight - 200,
                    child: TabsComponent()),
                SizedBox(
                  width: 150,
                  child: Wrap(
                    children: AppPages.routes.map((r) {
                      return ElevatedButton(
                          onPressed: () {
                            Get.toNamed(r.name);
                          },
                          child: Text(r.name));
                    }).toList(),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }));
  }
}
