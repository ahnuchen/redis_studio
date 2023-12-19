import 'dart:convert' show jsonDecode, jsonEncode;

import 'models/node.dart';

/// Defines the insertion mode adding a new [NodeModel] to the [TreeView].
enum InsertMode {
  prepend,
  append,
  insert,
}

/// Defines the controller needed to display the [TreeView].
///
/// Used by [TreeView] to display the nodes and selected node.
///
/// This class also defines methods used to manipulate data in
/// the [TreeView]. The methods ([addNode], [updateNode],
/// and [deleteNode]) are non-mutilating, meaning they will not
/// modify the tree but instead they will return a mutilated
/// copy of the data. You can then use your own logic to appropriately
/// update the [TreeView]. e.g.
///
/// ```dart
/// TreeViewController controller = TreeViewController(children: nodes);
/// Node node = controller.getNode('unique_key')!;
/// Node updatedNode = node.copyWith(
///   key: 'another_unique_key',
///   label: 'Another Node',
/// );
/// List<Node> newChildren = controller.updateNode(node.key, updatedNode);
/// controller = TreeViewController(children: newChildren);
/// ```
class TreeViewController {
  /// The data for the [TreeView].
  final List<NodeModel> children;

  /// The key of the select node in the [TreeView].
  final String? selectedKey;

  final List<String>? checkedKeys;

  TreeViewController({
    this.children = const [],
    this.selectedKey,
    this.checkedKeys,
  });

  /// Creates a copy of this controller but with the given fields
  /// replaced with the new values.
  TreeViewController copyWith<T>({
    List<NodeModel<T>>? children,
    String? selectedKey,
    List<String>? checkedKeys,
  }) {
    return TreeViewController(
      children: children ?? this.children,
      selectedKey: selectedKey ?? this.selectedKey,
      checkedKeys: checkedKeys ?? this.checkedKeys,
    );
  }

  /// Loads this controller with data from a JSON String
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.loadJSON(json: jsonString);
  /// });
  /// ```
  TreeViewController loadJSON<T>({String json = '[]'}) {
    List jsonList = jsonDecode(json);
    List<Map<String, dynamic>> list = List<Map<String, dynamic>>.from(jsonList);
    return loadMap<T>(list: list);
  }

  /// Loads this controller with data from a Map.
  /// This method expects the user to properly update the state
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.loadMap(map: dataMap);
  /// });
  /// ```
  TreeViewController loadMap<T>({List<Map<String, dynamic>> list = const []}) {
    List<NodeModel<T>> treeData =
        list.map((Map<String, dynamic> item) => NodeModel.fromMap<T>(item)).toList();
    return TreeViewController(
      children: treeData,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Adds a new node to an existing node identified by specified key.
  /// It returns a new controller with the new node added. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [TreeViewController.addNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withAddNode(key, newNode);
  /// });
  /// ```
  TreeViewController withAddNode<T>(
    String key,
    NodeModel<T> newNode, {
    NodeModel? parent,
    int? index,
    InsertMode mode = InsertMode.append,
  }) {
    List<NodeModel> _data =
        addNode<T>(key, newNode, parent: parent, mode: mode, index: index);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Replaces an existing node identified by specified key with a new node.
  /// It returns a new controller with the updated node replaced. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [TreeViewController.updateNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withUpdateNode(key, newNode);
  /// });
  /// ```
  TreeViewController withUpdateNode<T>(String key, NodeModel<T> newNode,
      {NodeModel? parent}) {
    List<NodeModel> _data = updateNode<T>(key, newNode, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Removes an existing node identified by specified key.
  /// It returns a new controller with the node removed. This method
  /// expects the user to properly place this call so that the state is
  /// updated.
  ///
  /// See [TreeViewController.deleteNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withDeleteNode(key);
  /// });
  /// ```
  TreeViewController withDeleteNode<T>(String key, {NodeModel? parent}) {
    List<NodeModel> _data = deleteNode<T>(key, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Toggles the expanded property of an existing node identified by
  /// specified key. It returns a new controller with the node toggled.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// See [TreeViewController.toggleNode] for info on optional parameters.
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withToggleNode(key, newNode);
  /// });
  /// ```
  TreeViewController withToggleNode<T>(String key, {NodeModel? parent}) {
    List<NodeModel> _data = toggleNode<T>(key, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  TreeViewController withToggleCheckNode<T>(String key, {NodeModel? parent}) {
    List<NodeModel> _data = toggleCheckNode<T>(key, parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Expands all nodes down to Node identified by specified key.
  /// It returns a new controller with the nodes expanded.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [TreeViewController.expandToNode].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withExpandToNode(key, newNode);
  /// });
  /// ```
  TreeViewController withExpandToNode(String key) {
    List<NodeModel> _data = expandToNode(key);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Collapses all nodes down to Node identified by specified key.
  /// It returns a new controller with the nodes collapsed.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [TreeViewController.collapseToNode].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withCollapseToNode(key, newNode);
  /// });
  /// ```
  TreeViewController withCollapseToNode(String key) {
    List<NodeModel> _data = collapseToNode(key);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Expands all nodes down to parent Node.
  /// It returns a new controller with the nodes expanded.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [TreeViewController.expandAll].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withExpandAll();
  /// });
  /// ```
  TreeViewController withExpandAll({NodeModel? parent}) {
    List<NodeModel> _data = expandAll(parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Collapses all nodes down to parent Node.
  /// It returns a new controller with the nodes collapsed.
  /// This method expects the user to properly place this call so
  /// that the state is updated.
  ///
  /// Internally uses [TreeViewController.collapseAll].
  ///
  /// ```dart
  /// setState((){
  ///   controller = controller.withCollapseAll();
  /// });
  /// ```
  TreeViewController withCollapseAll({NodeModel? parent}) {
    List<NodeModel> _data = collapseAll(parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  TreeViewController withUnCheckAll({NodeModel? parent}) {
    List<NodeModel> _data = unCheckAll(parent: parent);
    return TreeViewController(
      children: _data,
      selectedKey: this.selectedKey,
      checkedKeys: this.checkedKeys,
    );
  }

  /// Gets the node that has a key value equal to the specified key.
  NodeModel<T>? getNode<T>(String key, {NodeModel? parent}) {
    NodeModel<T>? _found;
    List<NodeModel> _children = parent == null ? this.children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      NodeModel child = iter.current;
      if (child.key == key) {
        _found = child as NodeModel<T>;
        break;
      } else {
        if (child.isParent) {
          _found = this.getNode<T>(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found;
  }

  /// Expands all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  List<NodeModel> expandAll({NodeModel? parent}) {
    List<NodeModel> _children = [];
    Iterator iter =
        parent == null ? this.children.iterator : parent.children.iterator;
    while (iter.moveNext()) {
      NodeModel child = iter.current;
      if (child.isParent) {
        _children.add(child.copyWith(
          expanded: true,
          children: this.expandAll(parent: child),
        ));
      } else {
        _children.add(child);
      }
    }
    return _children;
  }

  /// Collapses all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  List<NodeModel> collapseAll({NodeModel? parent}) {
    List<NodeModel> _children = [];
    Iterator iter =
        parent == null ? this.children.iterator : parent.children.iterator;
    while (iter.moveNext()) {
      NodeModel child = iter.current;
      if (child.isParent) {
        _children.add(child.copyWith(
          expanded: false,
          children: this.collapseAll(parent: child),
        ));
      } else {
        _children.add(child);
      }
    }
    return _children;
  }
  /// Collapses all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  List<NodeModel> unCheckAll({NodeModel? parent}) {
    List<NodeModel> _children = [];
    Iterator iter =
        parent == null ? this.children.iterator : parent.children.iterator;
    while (iter.moveNext()) {
      NodeModel child = iter.current;
      if (child.isParent) {
        _children.add(child.copyWith(
          checkStatus: CheckStatus.none,
          children: this.unCheckAll(parent: child),
        ));
      } else {
        _children.add(child.copyWith(checkStatus: CheckStatus.none));
      }
    }
    return _children;
  }

  /// Gets the parent of the node identified by specified key.
  NodeModel<T>? getParent<T>(String key, {NodeModel? parent}) {
    NodeModel? _found;
    List<NodeModel> _children = parent == null ? this.children : parent.children;
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      NodeModel child = iter.current;
      if (child.key == key) {
        _found = parent ?? child;
        break;
      } else {
        if (child.isParent) {
          _found = this.getParent<T>(key, parent: child);
          if (_found != null) {
            break;
          }
        }
      }
    }
    return _found == null ? null : _found as NodeModel<T>;
  }

  /// Expands a node and all of the node's ancestors so that the node is
  /// visible without the need to manually expand each node.
  List<NodeModel> expandToNode(String key) {
    List<String> _ancestors = [];
    String _currentKey = key;

    _ancestors.add(_currentKey);

    NodeModel? _parent = this.getParent(_currentKey);
    if (_parent != null) {
      while (_parent!.key != _currentKey) {
        _currentKey = _parent.key;
        _ancestors.add(_currentKey);
        _parent = this.getParent(_currentKey);
      }
      TreeViewController _this = this;
      _ancestors.forEach((String k) {
        NodeModel _node = _this.getNode(k)!;
        NodeModel _updated = _node.copyWith(expanded: true);
        _this = _this.withUpdateNode(k, _updated);
      });
      return _this.children;
    }
    return this.children;
  }

  /// Collapses a node and all of the node's ancestors without the need to
  /// manually collapse each node.
  List<NodeModel> collapseToNode(String key) {
    List<String> _ancestors = [];
    String _currentKey = key;

    _ancestors.add(_currentKey);

    NodeModel? _parent = this.getParent(_currentKey);
    if (_parent != null) {
      while (_parent!.key != _currentKey) {
        _currentKey = _parent.key;
        _ancestors.add(_currentKey);
        _parent = this.getParent(_currentKey);
      }
      TreeViewController _this = this;
      _ancestors.forEach((String k) {
        NodeModel _node = _this.getNode(k)!;
        NodeModel _updated = _node.copyWith(expanded: false);
        _this = _this.withUpdateNode(k, _updated);
      });
      return _this.children;
    }
    return this.children;
  }

  /// Adds a new node to an existing node identified by specified key. It optionally
  /// accepts an [InsertMode] and index. If no [InsertMode] is specified,
  /// it appends the new node as a child at the end. This method returns
  /// a new list with the added node.
  List<NodeModel> addNode<T>(
    String key,
    NodeModel<T> newNode, {
    NodeModel? parent,
    int? index,
    InsertMode mode = InsertMode.append,
  }) {
    List<NodeModel> __children = parent == null ? this.children : parent.children;
    return __children.map((NodeModel child) {
      if (child.key == key) {
        List<NodeModel> _children = child.children.toList(growable: true);
        if (mode == InsertMode.prepend) {
          _children.insert(0, newNode);
        } else if (mode == InsertMode.insert) {
          _children.insert(index ?? _children.length, newNode);
        } else {
          _children.add(newNode);
        }
        return child.copyWith(children: _children);
      } else {
        return child.copyWith(
          children: addNode<T>(
            key,
            newNode,
            parent: child,
            mode: mode,
            index: index,
          ),
        );
      }
    }).toList();
  }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  List<NodeModel> updateNode<T>(String key, NodeModel<T> newNode, {NodeModel? parent}) {
    List<NodeModel> _children = parent == null ? this.children : parent.children;
    return _children.map((NodeModel child) {
      if (child.key == key) {
        return newNode;
      } else {
        if (child.isParent) {
          return child.copyWith(
            children: updateNode<T>(
              key,
              newNode,
              parent: child,
            ),
          );
        }
        return child;
      }
    }).toList();
  }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  // List<Node> updateParent<T>( List<Node<T>> list){
  //   return list;
  // }

  CheckStatus toggleNodeStatus(CheckStatus status) {
    if (status == CheckStatus.full) {
      return CheckStatus.none;
    } else {
      return CheckStatus.full;
    }
  }

  /// Expands all node that are children of the parent node parameter. If no parent is passed, uses the root node as the parent.
  List<NodeModel> updateChildren(
      {required CheckStatus status, required NodeModel parent}) {
    List<NodeModel> _children = [];
    Iterator iter = parent.children.iterator;
    while (iter.moveNext()) {
      NodeModel child = iter.current;
      if (child.isParent) {
        _children.add(child.copyWith(
          checkStatus: status,
          children: this.updateChildren(status: status, parent: child),
        ));
      } else {
        _children.add(child.copyWith(checkStatus: status));
      }
    }
    return _children;
  }

  List<NodeModel> updateParent(String key, List<NodeModel> list) {
    getParentByList({String? key, NodeModel? parent}) {
      NodeModel? _found;
      List<NodeModel> _children = parent == null ? list : parent.children;
      Iterator iter = _children.iterator;
      while (iter.moveNext()) {
        NodeModel child = iter.current;
        if (child.key == key) {
          _found = parent ?? child;
          break;
        } else {
          if (child.isParent) {
            _found = getParentByList(parent: child, key: key);
            if (_found != null) {
              break;
            }
          }
        }
      }
      return _found == null ? null : _found as NodeModel;
    }

    getNodeByList({required String key, NodeModel? parent}) {
      NodeModel? _found;
      List<NodeModel> _children = parent == null ? list : parent.children;
      Iterator iter = _children.iterator;
      while (iter.moveNext()) {
        NodeModel child = iter.current;
        if (child.key == key) {
          _found = child as NodeModel;
          break;
        } else {
          if (child.isParent) {
            _found = getNodeByList(key: key, parent: child);
            if (_found != null) {
              break;
            }
          }
        }
      }
      return _found;
    }

    updateNodeByList(String key, NodeModel newNode, {NodeModel? parent}) {
      List<NodeModel> _children = parent == null ? list : parent.children;
      return _children.map((NodeModel child) {
        if (child.key == key) {
          return newNode;
        } else {
          if (child.isParent) {
            return child.copyWith(
              children: updateNodeByList(
                key,
                newNode,
                parent: child,
              ),
            );
          }
          return child;
        }
      }).toList();
    }

    List<String> _ancestors = [];
    String _currentKey = key;

    _ancestors.add(_currentKey);

    NodeModel? _parent = getParentByList(key: _currentKey);

    if (_parent != null) {
      while (_parent!.key != _currentKey) {
        _currentKey = _parent.key;
        _ancestors.add(_currentKey);
        _parent = getParentByList(key: _currentKey);
      }
      // List<Node> res = list;
      _ancestors.forEach((String k) {
        NodeModel _node = getNodeByList(key: k)!;
        if (_node.isParent) {
          NodeModel _updated =
              _node.copyWith(checkStatus: toggleParentNodeStatus(_node));
          list = updateNodeByList(k, _updated);
        }
      });
      return list;
    }
    return list;
  }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  List<NodeModel> toggleCheckNode<T>(String key, {NodeModel? parent}) {
    NodeModel<T>? _node = getNode<T>(key, parent: parent);

    var list;
    var sts = toggleNodeStatus(_node!.checkStatus);

    if (_node!.isParent) {
      list = updateNode<T>(
          key,
          _node!.copyWith(
              checkStatus: sts,
              children: updateChildren(status: sts, parent: _node)));
    } else {
      list = updateNode<T>(key, _node!.copyWith(checkStatus: sts));
    }
    return updateParent(key, list);
  }

  /// Updates an existing node identified by specified key. This method
  /// returns a new list with the updated node.
  CheckStatus toggleParentNodeStatus<T>(NodeModel par) {
    // Node<T>? _node = getNode<T>(key, parent: parent);
    var children = par!.children;
    if(children.length == 0) {
      return par.checkStatus;
    }
    var partChecked = false;
    var selected = 0;
    for (var i = 0; i < children.length; ++i) {
      var o = children[i];
      if (o.checkStatus == CheckStatus.full) {
        selected++;
      } else if (o.checkStatus == CheckStatus.half) {
        partChecked = true;
        break;
      }
    }
    var partCheckStatus;
    // 如果子孩子全都是选择的， 父节点就全选
    if (selected == children.length) {
      partCheckStatus = CheckStatus.full;
    } else if (partChecked || (selected < children.length && selected > 0)) {
      partCheckStatus = CheckStatus.half;
    } else {
      partCheckStatus = CheckStatus.none;
    }
    return partCheckStatus;
  }

  /// Toggles an existing node identified by specified key. This method
  /// returns a new list with the specified node toggled.
  List<NodeModel> toggleNode<T>(String key, {NodeModel? parent}) {
    NodeModel<T>? _node = getNode<T>(key, parent: parent);
    return updateNode<T>(key, _node!.copyWith(expanded: !_node.expanded));
  }

  /// Deletes an existing node identified by specified key. This method
  /// returns a new list with the specified node removed.
  List<NodeModel> deleteNode<T>(String key, {NodeModel? parent}) {
    List<NodeModel> _children = parent == null ? this.children : parent.children;
    List<NodeModel<T>> _filteredChildren = [];
    Iterator iter = _children.iterator;
    while (iter.moveNext()) {
      NodeModel<T> child = iter.current;
      if (child.key != key) {
        if (child.isParent) {
          _filteredChildren.add(child.copyWith(
            children: deleteNode<T>(key, parent: child),
          ));
        } else {
          _filteredChildren.add(child);
        }
      }
    }
    return _filteredChildren;
  }

  /// Get the current selected node. Returns null if there is no selectedKey
  NodeModel? get selectedNode {
    return this.selectedKey!.isEmpty ? null : getNode(this.selectedKey!);
  }

  /// Map representation of this object
  List<Map<String, dynamic>> get asMap {
    return children.map((NodeModel child) => child.asMap).toList();
  }

  @override
  String toString() {
    return jsonEncode(asMap);
  }
}
