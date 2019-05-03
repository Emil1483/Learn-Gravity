import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import '../nodes/rootNode.dart';
import '../ui_elements/custom_fab.dart';
import '../ui_elements/mode_fab.dart';
import '../ui_elements/grav_slider.dart';

class SpritewidgetContent extends StatelessWidget {
  final RootNode rootNode;

  SpritewidgetContent({
    @required this.rootNode,
  }) : assert(rootNode != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (BuildContext context) {
          rootNode.setContext(context);
          return SpriteWidget(rootNode);
        },
      ),
      floatingActionButton: CustomFab(
        mainColor: Theme.of(context).primaryColor,
        buttons: <Widget>[
          GravitySlider(rootNode: rootNode),
          ModeFab(rootNode: rootNode),
          FloatingActionButton(
            heroTag: "resetButton",
            backgroundColor: Theme.of(context).accentColor,
            onPressed: rootNode.reset,
          ),
          FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            heroTag: "infoButton",
            onPressed: () => print("Hello!"),
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
