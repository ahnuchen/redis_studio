import 'dart:collection';

import '../app/components/flutter_tree_view/src/models/node.dart';

class Utils {
  static keysToList(List keys) {
    return keys.map((e) => NodeModel(key: e, label: e)).toList();
  }

  static keysToTree({required List keys, String separator = ':'}) {
    var tree = {};
    for (var keyStr in keys) {
      var currentNode = tree;
      var keySplited = keyStr.split(separator);
      var lastIndex = keySplited.length - 1;
      for (int index = 0; index < keySplited.length; index++) {
        var value = keySplited[index];
        if (index == lastIndex) {
          currentNode['$keyStr`k`'] = {'keyNode': true, 'name': keyStr};
        } else {
          if (currentNode[value] == null) {
            currentNode[value] = currentNode[value] ?? {};
          }
        }
        currentNode = currentNode[value] ?? {};
      }
    }
    var res = formatTreeData(tree: tree);
    return res;
  }

  static List<NodeModel> formatTreeData(
      {required Map tree, String previousKey = '', String separator = ':'}) {
    List<NodeModel> list = [];
    for (var key in tree.keys) {
      NodeModel? node;
      if (tree[key]['keyNode'] == null && tree[key].keys.length > 0) {
        var tillNowKeyName = previousKey + key + separator;
        node = NodeModel(
          key: 'F$tillNowKeyName',
          label: key,
          children:
              formatTreeData(tree: tree[key], previousKey: tillNowKeyName),
        );
        node = node.copyWith(
            keyCount: node.children
                .map((e) => e.keyCount ?? 1)
                .reduce((value, element) => value + element));
      } else {
        node = NodeModel(key: key ?? '[Empty]', label: tree[key]['name']);
      }
      list.add(node);
    }
    return sortKeysAndFolder(list);
  }

  static sortKeysAndFolder(List<NodeModel> nodes) {
    nodes.sort((a, b) {
      // a & b are all keys
      if (a.children.isEmpty && b.children.isEmpty) {
        return a.label.compareTo(b.label);

      }
      // a & b are all folder
      if (a.children.isNotEmpty && b.children.isNotEmpty) {
        return a.label.compareTo(b.label);
      }

      // a is folder, b is key
      if (a.children.isNotEmpty) {
        return -1;
      }
      // a is key, b is folder

      return 1;
    });
    return nodes;
  }
}
