import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:get/get.dart';
import './stats.dart';
import 'package:flutter/cupertino.dart';
import '../../components/flutter_tree_view/flutter_treeview.dart';

class FlutterTreeViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(
      title: 'home',
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _selectedNode;
  late List<NodeModel> _nodes;
  late TreeViewController _treeViewController;
  bool docsOpen = true;
  bool deepExpanded = true;
  final Map<ExpanderPosition, Widget> expansionPositionOptions = const {
    ExpanderPosition.start: Text('Start'),
    ExpanderPosition.end: Text('End'),
  };
  final Map<ExpanderType, Widget> expansionTypeOptions = {
    ExpanderType.none: Container(),
    ExpanderType.caret: Icon(
      Icons.arrow_drop_down,
      size: 28,
    ),
    ExpanderType.arrow: Icon(Icons.arrow_downward),
    ExpanderType.chevron: Icon(Icons.expand_more),
    ExpanderType.plusMinus: Icon(Icons.add),
  };
  final Map<ExpanderModifier, Widget> expansionModifierOptions = {
    ExpanderModifier.none: ModContainer(ExpanderModifier.none),
    ExpanderModifier.circleFilled: ModContainer(ExpanderModifier.circleFilled),
    ExpanderModifier.circleOutlined:
        ModContainer(ExpanderModifier.circleOutlined),
    ExpanderModifier.squareFilled: ModContainer(ExpanderModifier.squareFilled),
    ExpanderModifier.squareOutlined:
        ModContainer(ExpanderModifier.squareOutlined),
  };
  ExpanderPosition _expanderPosition = ExpanderPosition.start;
  ExpanderType _expanderType = ExpanderType.caret;
  ExpanderModifier _expanderModifier = ExpanderModifier.none;
  bool _allowCheck = false;
  bool _supportParentSecondaryTap = false;

  @override
  void initState() {
    _nodes = [
      NodeModel(
        label: 'documents',
        key: 'docs',
        expanded: docsOpen,
        icon: docsOpen ? Icons.folder_open : Icons.folder,
        children: [
          NodeModel(
            label: 'personal',
            key: 'd3',
            checkStatus: CheckStatus.half,
            icon: Icons.input,
            iconColor: Colors.red,
            children: [
              NodeModel(
                checkStatus: CheckStatus.none,
                label: 'Poems.docx',
                key: 'pd1',
                icon: Icons.insert_drive_file,
              ),
              NodeModel(
                checkStatus: CheckStatus.full,
                label: 'Job Hunt',
                key: 'jh1',
                icon: Icons.input,
                children: [
                  NodeModel(
                    label: 'Resume.docx',
                    key: 'jh1a',
                    icon: Icons.insert_drive_file,
                  ),
                  NodeModel(
                    label: 'Cover Letter.docx',
                    key: 'jh1b',
                    icon: Icons.insert_drive_file,
                  ),
                ],
              ),
            ],
          ),
          NodeModel(
            label: 'Inspection.docx',
            key: 'd1',
//          icon: Icons.insert_drive_file),
          ),
          NodeModel(label: 'Invoice.docx', key: 'd2', icon: Icons.insert_drive_file),
        ],
      ),
      NodeModel(
          label: 'MeetingReport.xls',
          key: 'mrxls',
          icon: Icons.insert_drive_file),
      NodeModel(
        label: 'MeetingReport.pdf',
        key: 'mrpdf',
        // iconColor: Colors.green.shade300,
        // selectedIconColor: Colors.white,
        // icon: Icons.insert_drive_file
      ),
      NodeModel(label: 'Demo.zip', key: 'demo', icon: Icons.archive),
      NodeModel(
        label: 'empty folder',
        key: 'empty',
        parent: true,
      ),
    ];
    _selectedNode = _nodes[0].key;
    _treeViewController = TreeViewController(
      children: _nodes,
      selectedKey: _selectedNode,
    );

    super.initState();
  }

  ListTile _makeExpanderPosition() {
    return ListTile(
      title: Text('Expander Position'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionPositionOptions,
        groupValue: _expanderPosition,
        onValueChanged: (ExpanderPosition? newValue) {
          setState(() {
            _expanderPosition = newValue!;
          });
        },
      ),
    );
  }

  SwitchListTile _makeAllowCheck() {
    return SwitchListTile.adaptive(
      title: Text('Allow Check'),
      dense: true,
      value: _allowCheck,
      onChanged: (v) {
        setState(() {
          _allowCheck = v;
          if(!v) {
            _treeViewController = _treeViewController.withUnCheckAll();
          }
        });
      },
    );
  }

  SwitchListTile _makeSupportParentDoubleTap() {
    return SwitchListTile.adaptive(
      title: Text('Support Parent secondary Tap'),
      dense: true,
      value: _supportParentSecondaryTap,
      onChanged: (v) {
        setState(() {
          _supportParentSecondaryTap = v;
        });
      },
    );
  }

  ListTile _makeExpanderType() {
    return ListTile(
      title: Text('Expander Style'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionTypeOptions,
        groupValue: _expanderType,
        onValueChanged: (ExpanderType? newValue) {
          setState(() {
            _expanderType = newValue!;
          });
        },
      ),
    );
  }

  ListTile _makeExpanderModifier() {
    return ListTile(
      title: Text('Expander Modifier'),
      dense: true,
      trailing: CupertinoSlidingSegmentedControl(
        children: expansionModifierOptions,
        groupValue: _expanderModifier,
        onValueChanged: (ExpanderModifier? newValue) {
          setState(() {
            _expanderModifier = newValue!;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TreeViewTheme _treeViewTheme = TreeViewTheme(
      expanderTheme: ExpanderThemeData(
          type: _expanderType,
          modifier: _expanderModifier,
          position: _expanderPosition,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          padding: EdgeInsets.all(20),
          height: double.infinity,
          child: Column(
            children: <Widget>[
              Container(
                height: 220,
                child: Column(
                  children: <Widget>[
                    _makeExpanderPosition(),
                    _makeExpanderType(),
                    _makeExpanderModifier(),
                    _makeAllowCheck(),
                    _makeSupportParentDoubleTap(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: ContextMenuOverlay(
                    child: TreeView(
                      allowCheck: _allowCheck,
                      controller: _treeViewController,
                      supportParentSecondaryTap: _supportParentSecondaryTap,
                      onExpansionChanged: (key, expanded) =>
                          _expandNode(key, expanded),
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
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('Close Keyboard');
                  FocusScope.of(context).unfocus();
                },
                child: Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Text(_treeViewController.getNode(_selectedNode) == null
                      ? ''
                      : _treeViewController.getNode(_selectedNode)!.label),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CupertinoButton(
              child: Text('Node'),
              onPressed: () {
                setState(() {
                  _treeViewController = _treeViewController.copyWith(
                    children: _nodes,
                  );
                });
              },
            ),
            CupertinoButton(
              child: Text('JSON'),
              onPressed: () {
                setState(() {
                  _treeViewController =
                      _treeViewController.loadJSON(json: US_STATES_JSON);
                });
              },
            ),
//            CupertinoButton(
//              child: Text('Toggle'),
//              onPressed: _treeViewController.selectedNode != null &&
//                      _treeViewController.selectedNode.isParent
//                  ? () {
//                      setState(() {
//                        _treeViewController = _treeViewController
//                            .withToggleNode(_treeViewController.selectedKey);
//                      });
//                    }
//                  : null,
//            ),
            CupertinoButton(
              child: Text('Deep'),
              onPressed: () {
                String deepKey = 'jh1b';
                setState(() {
                  if (deepExpanded == false) {
                    List<NodeModel> newdata =
                        _treeViewController.expandToNode(deepKey);
                    _treeViewController =
                        _treeViewController.copyWith(children: newdata);
                    deepExpanded = true;
                  } else {
                    _treeViewController =
                        _treeViewController.withCollapseToNode(deepKey);
                    deepExpanded = false;
                  }
                });
              },
            ),
            CupertinoButton(
              child: Text('Edit'),
              onPressed: () {
                TextEditingController editingController = TextEditingController(
                    text: _treeViewController.selectedNode!.label);
                showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return CupertinoAlertDialog(
                        title: Text('Edit Label'),
                        content: Container(
                          height: 80,
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: CupertinoTextField(
                            controller: editingController,
                            autofocus: true,
                          ),
                        ),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('Cancel'),
                            isDestructiveAction: true,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          CupertinoDialogAction(
                            child: Text('Update'),
                            isDefaultAction: true,
                            onPressed: () {
                              if (editingController.text.isNotEmpty) {
                                setState(() {
                                  NodeModel? _node =
                                      _treeViewController.selectedNode;
                                  _treeViewController =
                                      _treeViewController.withUpdateNode(
                                          _treeViewController.selectedKey!,
                                          _node!.copyWith(
                                              label: editingController.text));
                                });
                                debugPrint(editingController.text);
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }

  _checkNode(String key, CheckStatus status) {
    // print(key);
    // print(status);
    setState(() {
      _treeViewController = _treeViewController.withToggleCheckNode(key);
    });
  }

  _expandNode(String key, bool expanded) {
    // String msg = '${expanded ? "Expanded" : "Collapsed"}: $key';
    // debugPrint(msg);
    // Node? node = _treeViewController.getNode(key);
    // if (node != null) {
    //   List<Node> updated;
    //   if (key == 'docs') {
    //     updated = _treeViewController.updateNode(
    //         key,
    //         node.copyWith(
    //           expanded: expanded,
    //           icon: expanded ? Icons.folder_open : Icons.folder,
    //         ));
    //   } else {
    //     updated = _treeViewController.updateNode(
    //         key, node.copyWith(expanded: expanded));
    //   }
    //   setState(() {
    //     if (key == 'docs') docsOpen = expanded;
    //     _treeViewController = _treeViewController.copyWith(children: updated);
    //   });
    // }
  }
}

class ModContainer extends StatelessWidget {
  final ExpanderModifier modifier;

  ModContainer(this.modifier, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color _backAltColor = Colors.grey.shade700;
    switch (modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = 1;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = _backAltColor;
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = 1;
        break;
    }
    return Container(
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
                width: _borderWidth,
                color: _backAltColor,
              ),
        color: _backColor,
      ),
      width: 15,
      height: 15,
    );
  }
}
