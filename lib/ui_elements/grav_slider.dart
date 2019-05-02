import 'package:flutter/material.dart';

import '../nodes/rootNode.dart';

class GravitySlider extends StatefulWidget {
  final RootNode rootNode;

  GravitySlider({@required this.rootNode}) : assert(rootNode != null);

  @override
  _GravitySliderState createState() => _GravitySliderState();
}

class _GravitySliderState extends State<GravitySlider> {

  double _value;

  @override
  Widget build(BuildContext context) {
    _value = widget.rootNode.gravity;
    return Transform.translate(
      offset: Offset(50, 0),
      child: SizedBox(
        width: 200,
        child: Slider(
          activeColor: Theme.of(context).accentColor,
          min: widget.rootNode.minG,
          max: widget.rootNode.maxG,
          onChanged: (double val) => setState(() {
                _value = val;
                widget.rootNode.setGravity(val);
              }),
          value: _value,
        ),
      ),
    );
  }
}
