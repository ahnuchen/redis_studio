import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redis_studio/config/translations/strings_enum.dart';

import 'logic.dart';

class NewConnectionPage extends GetView<NewConnectionLogic> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewConnectionLogic>(builder: (logic) {
      return Scaffold(
          appBar: AppBar(
            title: Text(Strings.new_connection.tr),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, style: BorderStyle.solid))),
                        padding: const EdgeInsets.only(left: 0, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.computer,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${Strings.host.tr}:'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller.hostInputController,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '127.0.0.1',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, style: BorderStyle.solid))),
                        padding: const EdgeInsets.only(left: 0, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.wifi,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${Strings.port.tr}:'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller.portInputController,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '6379',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, style: BorderStyle.solid))),
                        padding: const EdgeInsets.only(left: 0, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.person_2_outlined,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${Strings.username.tr}:'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller.usernameInputController,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Redis >= 6.0',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, style: BorderStyle.solid))),
                        padding: const EdgeInsets.only(left: 0, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.lock_open,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${Strings.password.tr}:'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller.pwdInputController,
                                obscureText: true,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Auth',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, style: BorderStyle.solid))),
                        padding: const EdgeInsets.only(left: 0, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.nat,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${Strings.connection_name.tr}:'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller.nameInputController,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '',
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                        const EdgeInsets.only(left: 40, right: 40, top: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5, style: BorderStyle.solid))),
                        padding: const EdgeInsets.only(left: 0, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 8),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.computer,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('${Strings.separator.tr}:'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: controller.separateInputController,
                                textAlign: TextAlign.left,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: Strings.separator_tip.tr,
                                    hintStyle: TextStyle(color: Colors.grey)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        floatingActionButton: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            OutlinedButton(onPressed: (){
              Get.back();
            }, child: Text(Strings.close.tr)),
            SizedBox(width: 20,),
            ElevatedButton(onPressed: (){
              controller.saveConnection();
            }, child: Text(Strings.save.tr)),
            SizedBox(width: 20,)
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
    ;
  }
}
