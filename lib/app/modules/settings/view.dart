import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redis_studio/config/theme/my_theme.dart';
import 'package:redis_studio/config/translations/localization_service.dart';
import 'package:redis_studio/config/translations/strings_enum.dart';
import 'logic.dart';

class SettingsPage extends GetView<SettingsLogic> {
  final langItems = [
    (value: 'en', label: 'English'),
    (value: 'zh', label: '简体中文'),
    (value: 'tw', label: '繁體中文')
  ];

  List<DropdownMenuItem> buildMenuItems() {
    return langItems
        .map(
          (e) => DropdownMenuItem(
            value: e.value,
            child: Text(e.label),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.settings.tr),
      ),
      body: GetBuilder<SettingsLogic>(builder: (logic) {
        return Column(
          children: [
            Container(
              width: Get.width,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Get.theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width,
                    padding: EdgeInsets.all(14),
                    child: Text(
                      Strings.ui_settings.tr,
                      style: TextStyle(fontSize: 20),
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: Get.theme.dividerColor))),
                  ),
                  Container(
                    padding: EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(Strings.dark_mode.tr),
                            Padding(padding: EdgeInsets.only(bottom: 10)),
                            Switch(
                                value: !logic.themeIsLight,
                                onChanged: (isOn) {
                                  logic.toggleTheme();
                                  MyTheme.changeTheme();
                                })
                          ],
                        ),
                        Column(
                          children: [
                            Text(Strings.select_lang.tr),
                            Padding(padding: EdgeInsets.only(bottom: 10)),
                            DropdownButton(
                                value: controller.localeKey,
                                focusColor: Colors.transparent,
                                items: buildMenuItems(),
                                onChanged: (se) {
                                  if (se!.isNotEmpty) {
                                    Get.updateLocale(LocalizationService
                                        .supportedLanguages[se]!);
                                    controller.toggleLang(se);
                                  }
                                })
                          ],
                        ),
                        Column(
                          children: [
                            Text(Strings.page_zoom.tr),
                            Padding(padding: EdgeInsets.only(bottom: 10)),
                            Slider(
                              value: controller.textScale * 10,
                              min: 5,
                              max: 20,
                              divisions: 15,
                              // semanticFormatterCallback: (value){
                              //   print(value);
                              //   return value.toString();
                              // },
                              label: controller.textScale.toString(),
                              onChanged: (v){
                                controller.setFontScale(v);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
