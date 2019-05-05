import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import '../nodes/rootNode.dart';
import '../ui_elements/custom_fab.dart';

class SpritewidgetContent extends StatelessWidget {
  final RootNode rootNode;
  final CustomFab customFab;

  SpritewidgetContent({
    @required this.rootNode,
    @required this.customFab,
  })  : assert(rootNode != null),
        assert(customFab != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SpriteWidget(rootNode),
      floatingActionButton: customFab,
    );
  }
}
