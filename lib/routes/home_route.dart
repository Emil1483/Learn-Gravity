import 'package:flutter/material.dart';

import '../ui_elements/backdrop.dart';
import '../nodes/rootNode.dart';

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    RootNode rootNode = RootNode(size: size);

    return BackdropPage(
      rootNode: rootNode,
    );
  }
}
