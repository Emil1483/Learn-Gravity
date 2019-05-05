import 'package:flutter/material.dart';

import '../nodes/rootNode.dart';

class InheritedRootNode extends InheritedWidget {
  final Widget child;
  final RootNode _rootNode = RootNode(size: Size(100, 100));

  InheritedRootNode({this.child});
  

  RootNode get rootNode => _rootNode;

  @override
  bool updateShouldNotify(InheritedRootNode oldWidget) {
    return true;
  }


  static InheritedRootNode of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InheritedRootNode);
}
