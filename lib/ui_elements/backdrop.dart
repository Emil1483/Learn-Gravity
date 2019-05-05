import 'package:flutter/material.dart';

import '../nodes/rootNode.dart';
import '../ui_elements/custom_fab.dart';
import '../ui_elements/mode_fab.dart';
import '../ui_elements/grav_slider.dart';
import '../routes/info_route.dart';
import '../routes/spritewidget_content.dart';

class BackdropPage extends StatefulWidget {
  final RootNode rootNode;

  BackdropPage({
    @required this.rootNode,
  }) : assert(rootNode != null);

  @override
  _BackdropPageState createState() => _BackdropPageState();
}

class _BackdropPageState extends State<BackdropPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  static const _PANEL_HEADER_HEIGHT = 64.0;
  static const _PANEL_HEADER_PEAKING = 0.0;

  CustomFab customFab;
  final _customFabKey = GlobalKey<CustomFabState>();
  final _modeFabKey = GlobalKey<ModeFabState>();

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 100), value: 0.0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  bool get _isPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  void _panelUp() {
    if (!_isPanelVisible) {
      _controller.fling(velocity: 1.0);
      _customFabKey.currentState.down();
    }
  }

  void _panelDown() {
    if (_isPanelVisible) {
      _controller.fling(velocity: -1.0);
      _customFabKey.currentState.down();
    }
  }

  Animation<RelativeRect> _getPanelAnimation(BoxConstraints constraints) {
    final double top = constraints.biggest.height;
    final double bottom = 0;
    return RelativeRectTween(
      begin:
          RelativeRect.fromLTRB(0.0, top - _PANEL_HEADER_PEAKING, 0.0, bottom),
      end: RelativeRect.fromLTRB(0.0, _PANEL_HEADER_HEIGHT, 0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    customFab = CustomFab(
      key: _customFabKey,
      mainColor: Theme.of(context).primaryColor,
      buttons: <Widget>[
        GravitySlider(
          rootNode: widget.rootNode,
        ),
        ModeFab(
          key: _modeFabKey,
        ),
        FloatingActionButton(
          heroTag: "resetButton",
          backgroundColor: Theme.of(context).accentColor,
          onPressed: widget.rootNode.reset,
        ),
        FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          heroTag: "infoButton",
          onPressed: _panelUp,
          child: Icon(Icons.info_outline),
        ),
      ],
    );

    final ThemeData theme = Theme.of(context);
    final animation = _getPanelAnimation(constraints);
    widget.rootNode.setModeFabKey(_modeFabKey);
    return Container(
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          SpritewidgetContent(
            rootNode: widget.rootNode,
            customFab: customFab,
          ),
          PositionedTransition(
            rect: animation,
            child: Material(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 16),
                child: InfoRoute(onBackPressed: _panelDown),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.rootNode.setOnTappedFunction(_panelDown);
    return LayoutBuilder(
      builder: _buildStack,
    );
  }
}
