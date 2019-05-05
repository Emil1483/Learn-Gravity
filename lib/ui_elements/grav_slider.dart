import 'package:flutter/material.dart';

import '../nodes/rootNode.dart';
import '../inheritedWidgets/inheritedRootNode.dart';

class GravitySlider extends StatefulWidget {
  @override
  _GravitySliderState createState() => _GravitySliderState();
}

class _GravitySliderState extends State<GravitySlider> {

  double _value;

  @override
  Widget build(BuildContext context) {
    RootNode rootNode = InheritedRootNode.of(context).rootNode;
    _value = rootNode.gravity;
    return Transform.translate(
      offset: Offset(50, 0),
      child: SizedBox(
        width: 200,
        child: Slider(
          activeColor: Theme.of(context).accentColor,
          min: rootNode.minG,
          max: rootNode.maxG,
          onChanged: (double val) => setState(() {
                _value = val;
                rootNode.setGravity(val);
              }),
          value: _value,
        ),
      ),
    );
  }
}
