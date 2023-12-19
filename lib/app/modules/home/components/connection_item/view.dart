import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:redis/redis.dart';
import 'package:redis_studio/app/data/models/connections_model.dart';
import 'package:redis_studio/app/modules/home/components/key_list/view.dart';
import 'package:redis_studio/config/translations/strings_enum.dart';
import 'package:redis_studio/utils/redis_commands.dart';
import '../../../../data/local/redis_connnect.dart';

class ConnectionItemComponent extends StatefulWidget {
  ConnectionConfig cfg;

  ConnectionItemComponent({Key? key, required ConnectionConfig this.cfg})
      : super(key: key);

  @override
  State<ConnectionItemComponent> createState() =>
      _ConnectionItemComponentState();
}

class _ConnectionItemComponentState extends State<ConnectionItemComponent> {
  ExpandableController expandController =
      ExpandableController(initialExpanded: false);
  GlobalKey<KeyListState> keyListState = GlobalKey<KeyListState>();

  final _connect = RedisConnect();
  EnhanceCommand? command;
  int dbsCount = 1;
  int selectedDb = 0;
  bool isExactSearch = false;

  TextEditingController searchKeyInputController = TextEditingController();

  onToggleExactSearch() {
    setState(() {
      isExactSearch = !isExactSearch;
    });
  }
  onDbChange(v) {
    setState(() {
      selectedDb = v!;
    });
    command?.command.send_object(['select', v!]).then((value) {
      keyListState.currentState?.scanAllKeys(command);
    });
  }

  getAllDatabases() {
    command?.command.send_object(['config', 'get', 'databases']).then((value) {
      print('alldatabases:${value.toString()}');
      setState(() {
        dbsCount = int.parse(value[1]);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    expandController?.addListener(() {
      print('expandController.expanded:${expandController.expanded}');
      var cfg = widget.cfg;
      if (expandController.expanded) {
        if (command == null) {
          _connect.createConnection(cfg).then((value) {
            setState(() {
              command = EnhanceCommand(value);
              keyListState.currentState?.scanAllKeys(command);
              getAllDatabases();
            });
          }).catchError((err) {
            print('Errorrrrrrrr: $err'); // Prints 401.
            showToast(err.toString());
            expandController.expanded = false;
          });
        } else {
          keyListState.currentState?.scanAllKeys(command);
        }
      }
    });
  }

  @override
  dispose(){
    setState(() {
      command?.command.get_connection().close();
      command = null;
    });
    super.dispose();
  }


  buildDbSelect() {
    return List.generate(dbsCount, (index) => index)
        .map((e) => DropdownMenuItem(
              child: Text('db$e'),
              value: e,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // var expandController = CustomExpandController.of(context);

    var cfg = widget.cfg;
    return ExpandableNotifier(
      controller: expandController,
      child: ScrollOnExpand(
        child: ExpandablePanel(
          theme: const ExpandableThemeData(
            useInkWell: true,
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToExpand: false,
            tapBodyToCollapse: false,
            hasIcon: true,
            iconColor: Colors.grey,
          ),
          collapsed: Container(),
          expanded: Column(
            children: [
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 100,
                    child: DropdownButton(
                        focusColor: Colors.transparent,
                        value: selectedDb,
                        items: buildDbSelect(),
                        onChanged: onDbChange),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(Icons.add),
                          label: Text('${Strings.newnew.tr}Key'))),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchKeyInputController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                          // border: InputBorder.none,
                          hintText: Strings.enter_to_search.tr,
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, right: 8),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                            tooltip: Strings.exact_search.tr,
                            onPressed: onToggleExactSearch,
                            icon: Icon(isExactSearch
                                ? Icons.check_box_sharp
                                : Icons.check_box_outline_blank)),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[ KeyList(key: keyListState, command:command,),],
              ),

            ],
          ),
          header: Text(cfg.name ?? '${cfg.host}:${cfg.port}'),
        ),
      ),
    );
  }
}
