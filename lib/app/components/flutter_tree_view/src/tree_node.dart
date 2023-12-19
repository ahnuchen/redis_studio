import 'dart:math' show pi;

import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redis_studio/config/translations/strings_enum.dart';

import 'tree_view.dart';
import './tree_view_theme.dart';
import 'expander_theme_data.dart';
import 'models/node.dart';

const double _kBorderWidth = 0.75;

/// Wraps any widget in a GestureDetector and calls [ContextMenuOverlay].show
class ContextMenuRegionCustom extends StatelessWidget {
  const ContextMenuRegionCustom(
      {Key? key,
      required this.child,
      required this.contextMenu,
      this.isEnabled = true,
      this.enableLongPress = true,
      this.onSecondaryTap})
      : super(key: key);
  final Widget child;
  final Widget contextMenu;
  final bool isEnabled;
  final bool enableLongPress;
  final onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    void showMenu() {
      // calculate widget position on screen
      context.contextMenuOverlay.show(contextMenu);
      if (onSecondaryTap != null) {
        onSecondaryTap();
      }
    }

    if (isEnabled == false) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onSecondaryTap: showMenu,
      onLongPress: enableLongPress ? showMenu : null,
      child: child,
    );
  }
}

/// Defines the [TreeNode] widget.
///
/// This widget is used to display a tree node and its children. It requires
/// a single [Node] value. It uses this node to display the state of the
/// widget. It uses the [TreeViewTheme] to handle the appearance and the
/// [TreeView] properties to handle to user actions.
///
/// __This class should not be used directly!__
/// The [TreeView] and [TreeViewController] handlers the data and rendering
/// of the nodes.
class TreeNode extends StatefulWidget {
  /// The node object used to display the widget state
  final NodeModel node;

  const TreeNode({Key? key, required this.node}) : super(key: key);

  @override
  _TreeNodeState createState() => _TreeNodeState();
}

class _TreeNodeState extends State<TreeNode>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  late AnimationController _controller;
  late Animation<double> _heightFactor;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _isExpanded = widget.node.expanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    TreeView? _treeView = TreeView.of(context);
    _controller.duration = _treeView!.theme.expandSpeed;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TreeNode oldWidget) {
    if (widget.node.expanded != oldWidget.node.expanded) {
      setState(() {
        _isExpanded = widget.node.expanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {});
          });
        }
      });
    } else if (widget.node != oldWidget.node) {
      setState(() {});
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleExpand() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {});
        });
      }
      widget.node.expanded = !widget.node.expanded;
    });
    if (_treeView!.onExpansionChanged != null)
      _treeView.onExpansionChanged!(widget.node.key, _isExpanded);
  }

  void _handleTap() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView!.onNodeTap != null) {
      _treeView.onNodeTap!(widget.node.key);
    }
  }

  void _handleCheck() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    if (_treeView!.onNodeCheck != null) {
      _treeView.onNodeCheck!(widget.node.key, widget.node.checkStatus);
    }
  }

  void _handleSecondaryTap() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    print('_handleSecondaryTap node:');
    print('_handleSecondaryTap node end:');
    if (_treeView!.onNodeSecondaryTap != null) {
      _treeView.onNodeSecondaryTap!(widget.node.key);
    }
  }

  Widget _buildNodeExpander() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView!.theme;
    if (_theme.expanderTheme.type == ExpanderType.none) return Container();
    return widget.node.isParent
        ? GestureDetector(
            onTap: () => _handleExpand(),
            child: Row(
              children: <Widget>[
                _TreeNodeExpander(
                  speed: _controller.duration!,
                  expanded: widget.node.expanded,
                  themeData: _theme.expanderTheme,
                ),
                Icon(
                  widget.node.expanded ? Icons.folder_open : Icons.folder,
                  color: _theme.expanderTheme.color,
                  size: _theme.expanderTheme.size,
                ),
              ],
            ),
          )
        : Container(width: _theme.expanderTheme.size);
  }

  Widget _buildNodeIcon() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView!.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    return Container(
      alignment: Alignment.center,
      width:
          widget.node.hasIcon ? _theme.iconTheme.size! + _theme.iconPadding : 0,
      child: widget.node.hasIcon
          ? Icon(
              widget.node.icon,
              size: _theme.iconTheme.size,
              color: isSelected
                  ? widget.node.selectedIconColor == null
                      ? _theme.colorScheme.onPrimary
                      : widget.node.selectedIconColor
                  : widget.node.iconColor == null
                      ? _theme.iconTheme.color
                      : widget.node.iconColor,
            )
          : null,
    );
  }

  buildChildWidget(String title, bool expandful) {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView!.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    Widget txt = Text(
      title,
      softWrap: widget.node.isParent
          ? _theme.parentLabelOverflow == null
          : _theme.labelOverflow == null,
      overflow: widget.node.isParent
          ? _theme.parentLabelOverflow
          : _theme.labelOverflow,
      style: widget.node.isParent
          ? _theme.parentLabelStyle.copyWith(
              fontWeight: _theme.parentLabelStyle.fontWeight,
              color: isSelected
                  ? _theme.colorScheme.onPrimary
                  : _theme.parentLabelStyle.color,
            )
          : _theme.labelStyle.copyWith(
              fontWeight: _theme.labelStyle.fontWeight,
              color: isSelected ? _theme.colorScheme.onPrimary : null,
            ),
    );
    return expandful
        ? Expanded(
            child: txt,
          )
        : txt;
  }

  Widget _buildNodeLabel() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView!.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    // final icon = _buildNodeIcon();
    List<Widget> cls = [
      buildChildWidget(widget.node.label, true),
    ];
    if (widget.node.keyCount != null) {
      cls.add(buildChildWidget('(${widget.node.keyCount.toString()})', false));
    }
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _theme.verticalSpacing ?? (_theme.dense ? 10 : 15),
        horizontal: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: cls,
      ),
    );
  }

  Widget _buildNodeChecker() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView!.theme;
    if (!_treeView!.allowCheck) {
      return Container();
    } else {
      var _checkIcon;
      if (widget.node.checkStatus == CheckStatus.full) {
        _checkIcon = Icons.check_box;
      } else if (widget.node.checkStatus == CheckStatus.half) {
        _checkIcon = Icons.indeterminate_check_box_sharp;
      } else if (widget.node.checkStatus == CheckStatus.none) {
        _checkIcon = Icons.check_box_outline_blank;
      } else {
        _checkIcon = Icons.check_box_outline_blank;
      }
      return _treeView.onNodeSecondaryTap != null
          ? ContextMenuRegionCustom(
              onSecondaryTap: _handleSecondaryTap,
              contextMenu: (widget.node.isParent
                      ? _treeView.parentContextMenu
                      : _treeView.childContextMenu) ??
                  TextContextMenu(data: widget.node.label),
              child: IconButton(
                onPressed: _handleCheck,
                icon: Icon(
                  _checkIcon,
                  size: _theme.expanderTheme.size,
                  // color: _theme.expanderTheme.color ?? Colors.black,
                ),
              ),
            )
          : IconButton(
              onPressed: _handleCheck,
              icon: Icon(
                _checkIcon,
                size: _theme.expanderTheme.size,
                color: _theme.expanderTheme.color ?? Colors.black,
              ),
            );
    }
  }

  Widget _buildNodeWidget() {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    TreeViewTheme _theme = _treeView!.theme;
    bool isSelected = _treeView.controller.selectedKey != null &&
        _treeView.controller.selectedKey == widget.node.key;
    bool canCheckParent = _treeView.allowCheck;
    final arrowContainer = _buildNodeExpander();
    final checkContainer = _buildNodeChecker();
    final labelContainer = _treeView.nodeBuilder != null
        ? _treeView.nodeBuilder!(context, widget.node)
        : _buildNodeLabel();
    Widget _tappable = _treeView.onNodeSecondaryTap != null
        ? ContextMenuRegionCustom(
            onSecondaryTap: _handleSecondaryTap,
            contextMenu: _treeView.childContextMenu ??
                TextContextMenu(data: widget.node.label),
            child: InkWell(
              onTap: _handleTap,
              child: labelContainer,
            ),
          )
        : InkWell(
            onTap: _handleTap,
            child: labelContainer,
          );
    if (widget.node.isParent) {
      if (_treeView.supportParentSecondaryTap && canCheckParent) {
        _tappable = ContextMenuRegionCustom(
          onSecondaryTap: _handleSecondaryTap,
          contextMenu: _treeView.parentContextMenu ??
              TextContextMenu(data: widget.node.label),
          child: InkWell(
            onTap: canCheckParent ? _handleTap : _handleExpand,
            child: labelContainer,
          ),
        );
      } else if (_treeView.supportParentSecondaryTap) {
        _tappable = ContextMenuRegionCustom(
          onSecondaryTap: _handleSecondaryTap,
          contextMenu: _treeView.parentContextMenu ??
              TextContextMenu(data: widget.node.label),
          child: InkWell(
            onTap: _handleExpand,
            child: labelContainer,
          ),
        );
      } else {
        _tappable = InkWell(
          onTap: canCheckParent ? _handleTap : _handleExpand,
          child: labelContainer,
        );
      }
    }
    return Container(
      color: isSelected ? _theme.colorScheme.primary.withOpacity(0.5) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _theme.expanderTheme.position == ExpanderPosition.end
            ? <Widget>[
                checkContainer,
                Expanded(
                  child: _tappable,
                ),
                arrowContainer,
              ]
            : <Widget>[
                checkContainer,
                arrowContainer,
                Expanded(
                  child: _tappable,
                ),
              ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TreeView? _treeView = TreeView.of(context);
    assert(_treeView != null, 'TreeView must exist in context');
    final bool closed =
        (!_isExpanded || !widget.node.expanded) && _controller.isDismissed;
    final nodeWidget = _buildNodeWidget();
    return widget.node.isParent
        ? AnimatedBuilder(
            animation: _controller.view,
            builder: (BuildContext context, Widget? child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  nodeWidget,
                  ClipRect(
                    child: Align(
                      heightFactor: _heightFactor.value,
                      child: child,
                    ),
                  ),
                ],
              );
            },
            child: closed
                ? null
                : Container(
                    margin: EdgeInsets.only(
                        left: _treeView!.theme.horizontalSpacing ??
                            _treeView.theme.iconTheme.size!),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: widget.node.children.map((NodeModel node) {
                          return TreeNode(node: node);
                        }).toList()),
                  ),
          )
        : Container(
            child: nodeWidget,
          );
  }
}

class _TreeNodeExpander extends StatefulWidget {
  final ExpanderThemeData themeData;
  final bool expanded;
  final Duration _expandSpeed;

  const _TreeNodeExpander({
    required Duration speed,
    required this.themeData,
    required this.expanded,
  }) : _expandSpeed = speed;

  @override
  _TreeNodeExpanderState createState() => _TreeNodeExpanderState();
}

class _TreeNodeExpanderState extends State<_TreeNodeExpander>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    bool isEnd = widget.themeData.position == ExpanderPosition.end;
    if (widget.themeData.type != ExpanderType.plusMinus) {
      controller = AnimationController(
        duration: widget.themeData.animated
            ? isEnd
                ? widget._expandSpeed * 0.625
                : widget._expandSpeed
            : Duration(milliseconds: 0),
        vsync: this,
      );
      animation = Tween<double>(
        begin: 0,
        end: isEnd ? 180 : 90,
      ).animate(controller);
    } else {
      controller =
          AnimationController(duration: Duration(milliseconds: 0), vsync: this);
      animation = Tween<double>(begin: 0, end: 0).animate(controller);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_TreeNodeExpander oldWidget) {
    if (widget.themeData != oldWidget.themeData ||
        widget.expanded != oldWidget.expanded) {
      bool isEnd = widget.themeData.position == ExpanderPosition.end;
      setState(() {
        if (widget.themeData.type != ExpanderType.plusMinus) {
          controller.duration = widget.themeData.animated
              ? isEnd
                  ? widget._expandSpeed * 0.625
                  : widget._expandSpeed
              : Duration(milliseconds: 0);
          animation = Tween<double>(
            begin: 0,
            end: isEnd ? 180 : 90,
          ).animate(controller);
        } else {
          controller.duration = Duration(milliseconds: 0);
          animation = Tween<double>(begin: 0, end: 0).animate(controller);
        }
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  Color? _onColor(Color? color) {
    if (color != null) {
      if (color.computeLuminance() > 0.6) {
        return Colors.black;
      } else {
        return Colors.white;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    IconData _arrow;
    double _iconSize = widget.themeData.size;
    double _borderWidth = 0;
    BoxShape _shapeBorder = BoxShape.rectangle;
    Color _backColor = Colors.transparent;
    Color? _iconColor =
        widget.themeData.color ?? Theme.of(context).iconTheme.color;
    switch (widget.themeData.modifier) {
      case ExpanderModifier.none:
        break;
      case ExpanderModifier.circleFilled:
        _shapeBorder = BoxShape.circle;
        _backColor = widget.themeData.color ?? Colors.black;
        _iconColor = _onColor(_backColor);
        break;
      case ExpanderModifier.circleOutlined:
        _borderWidth = _kBorderWidth;
        _shapeBorder = BoxShape.circle;
        break;
      case ExpanderModifier.squareFilled:
        _backColor = widget.themeData.color ?? Colors.black;
        _iconColor = _onColor(_backColor);
        break;
      case ExpanderModifier.squareOutlined:
        _borderWidth = _kBorderWidth;
        break;
    }
    switch (widget.themeData.type) {
      case ExpanderType.chevron:
        _arrow = Icons.expand_more;
        break;
      case ExpanderType.arrow:
        _arrow = Icons.arrow_downward;
        _iconSize = widget.themeData.size > 20
            ? widget.themeData.size - 8
            : widget.themeData.size;
        break;
      case ExpanderType.none:
      case ExpanderType.caret:
        _arrow = Icons.arrow_drop_down;
        break;
      case ExpanderType.plusMinus:
        _arrow = widget.expanded ? Icons.remove : Icons.add;
        break;
    }

    Icon _icon = Icon(
      _arrow,
      size: _iconSize,
      color: _iconColor,
    );

    if (widget.expanded) {
      controller.reverse();
    } else {
      controller.forward();
    }
    return Container(
      width: widget.themeData.size + 2,
      height: widget.themeData.size + 2,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: _shapeBorder,
        border: _borderWidth == 0
            ? null
            : Border.all(
                width: _borderWidth,
                color: widget.themeData.color ?? Colors.black,
              ),
        color: _backColor,
      ),
      child: AnimatedBuilder(
        animation: controller,
        child: _icon,
        builder: (context, child) {
          return Transform.rotate(
            angle: animation.value * (-pi / 180),
            child: child,
          );
        },
      ),
    );
  }
}
