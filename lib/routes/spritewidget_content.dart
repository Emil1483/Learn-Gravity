import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import '../ui_elements/custom_fab.dart';
import '../inheritedWidgets/inheritedRootNode.dart';

class SpritewidgetContent extends StatelessWidget {
  final CustomFab customFab;

  SpritewidgetContent({
    @required this.customFab,
  }) : assert(customFab != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SpriteWidget(InheritedRootNode.of(context).rootNode),
      floatingActionButton: customFab,
    );
  }
}
