import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Popup extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context) fabPressed;
  final Widget fabChild;

  Popup({
    @required this.child,
    this.fabPressed,
    this.fabChild = const Icon(Icons.done),
  }) : assert(child != null);

  @override
  _Popuptate createState() => _Popuptate();
}

class _Popuptate extends State<Popup> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double h = 250;
    final double w = 350;
    final double p = 32;

    return Center(
      child: Container(
        height: size.height < h + p*2 ? size.height - p*2 : h,
        width: size.width < w + p*2 ? size.width - p*2 : w,
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Stack(
          children: <Widget>[
            widget.child,
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: FloatingActionButton(
                  onPressed: () {
                    if (widget.fabPressed == null) {
                      Navigator.of(context).pop();
                    } else {
                      widget.fabPressed(context);
                    }
                  },
                  child: widget.fabChild,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
