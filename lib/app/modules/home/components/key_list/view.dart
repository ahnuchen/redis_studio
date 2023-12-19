import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redis_studio/config/translations/strings_enum.dart';
import 'package:redis_studio/utils/redis_commands.dart';
import 'package:redis_studio/utils/utils.dart';
import '../../../../components/flutter_tree_view/flutter_treeview.dart';

class KeyList extends StatefulWidget {
  late EnhanceCommand? command;

  KeyList({Key? key, EnhanceCommand? this.command}) : super(key: key);

  @override
  State<KeyList> createState() => KeyListState();
}

class KeyListState extends State<KeyList> {
  List allKeys = [];
  late String _selectedNode;
  late List<NodeModel> _nodes;
  late TreeViewController _treeViewController = TreeViewController();
  bool allowCheck = false;

  scanAllKeys(EnhanceCommand? command) {
    command?.scan(500).then((value) {
      setState(() {
        print('scand value ');
        print(value);
        allKeys = value[1];
        // _nodes = Utils.keysToList(allKeys);
        _nodes = Utils.keysToTree(keys: List<String>.from(allKeys));
        // _selectedNode = _nodes[0].key;
        _treeViewController = TreeViewController(
          children: _nodes,
          // selectedKey: _selectedNode,
        );
      });
    });
  }
  _checkNode(String key, CheckStatus status) {
    // print(key);
    // print(status);
    setState(() {
      _treeViewController = _treeViewController.withToggleCheckNode(key);
    });
  }

  onMultiSelectClick(){
    print('multiSelect');
    setState(() {
      allowCheck = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    TreeViewTheme _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
          // color: Colors.grey.shade800,
          size: 20,
          color: Theme.of(context).primaryColor),
      labelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.3,
      ),
      parentLabelStyle: TextStyle(
        fontSize: 16,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).primaryColor,
      ),
      iconTheme: IconThemeData(
        size: 18,
        color: Colors.grey.shade800,
      ),
      colorScheme: Theme.of(context).colorScheme,
    );
    if (widget.command == null) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: CircularProgressIndicator(),
      );
    }
    if (allKeys.length == 0) {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Text(Strings.tree_emptyText.tr),
      );
    }
    return Expanded(
      flex: 1,
      child: TreeView(
        shrinkWrap: true,
        // primary: true,
        allowCheck: allowCheck,
        controller: _treeViewController,
        supportParentSecondaryTap: true,
        onNodeCheck: (key, status) => _checkNode(key, status),
        onNodeSecondaryTap: (key) {
          setState(() {
            _selectedNode = key;
            _treeViewController =
                _treeViewController.copyWith(selectedKey: key);
          });
        },
        onNodeTap: (key) {
          debugPrint('Selected: $key');
          setState(() {
            _selectedNode = key;
            _treeViewController = _treeViewController.copyWith(
                selectedKey: key,
                children: _treeViewController.toggleCheckNode(key));
          });
        },
        theme: _treeViewTheme,
        parentContextMenu: GenericContextMenu(
          buttonConfigs: [
            ContextMenuButtonConfig(
              Strings.multiple_select.tr,
              onPressed: onMultiSelectClick,
            ),
            ContextMenuButtonConfig(
              "Copy",
              onPressed: () => {},
            )
          ],
        ),
        childContextMenu: GenericContextMenu(
          buttonConfigs: [
            ContextMenuButtonConfig(
              Strings.multiple_select.tr,
              onPressed: onMultiSelectClick,
            ),
            ContextMenuButtonConfig(
              "Copy",
              onPressed: () => {},
            )
          ],
        )
      ),
    );
  }
}
