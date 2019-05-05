import 'package:flutter/material.dart';

import '../ui_elements/backdrop.dart';
import '../nodes/rootNode.dart';
import '../inheritedWidgets/inheritedRootNode.dart';

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    RootNode rootNode = InheritedRootNode.of(context).rootNode;
    rootNode.setSize(size);

    return BackdropPage();
  }
}
