import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import '../ui_elements/custom_fab.dart';
import '../ui_elements/grav_slider.dart';
import '../inheritedWidgets/inheritedRootNode.dart';

class SpritewidgetContent extends StatelessWidget {
  final CustomFab customFab;
  final GravitySlider gravitySlider;

  SpritewidgetContent({
    @required this.customFab,
    @required this.gravitySlider,
  })  : assert(customFab != null),
        assert(gravitySlider != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment(0, 1),
        children: <Widget>[
          SpriteWidget(InheritedRootNode.of(context).rootNode),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 2,
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.symmetric(vertical: 42.0, horizontal: 22.0),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: gravitySlider,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.0, bottom: 16.0),
                child: customFab,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
