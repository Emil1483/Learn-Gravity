import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import './point.dart';
import '../enums/modes.dart';

class RootNode extends NodeWithSize {
  Modes mode = Modes.Nothing;

  BuildContext context;

  final double _pointsSpread = 30;
  final double _addPointDensity = 15;
  final double minG = -10;
  final double maxG = 20;
  double g = 6;
  final int _maxFpsSeen = 5;
  final double _minFps = 50;
  final double _framesBeforeToast = 200;

  double _numRecentlyKilled = 0;
  double _toastTimer = 0;
  bool _tickToastTimer = false;
  double _avgFps = 0;
  int _fpsSeen = 0;

  //TODO: Get better icons
  //TODO: Expand the about page to include learning material
  //TODO: Add points with negative mass
  //TODO: Make the info route part of a backdrop

  RootNode({@required Size size}) : super(size) {
    assert(size != null);

    userInteractionEnabled = true;
    handleMultiplePointers = true;

    _addStarterPoints();
  }

  void _addStarterPoints() {
    double m1 = 10;
    double m2 = 5;
    double r1 = 25;
    double r2 = r1 * m1 / m2;
    double v1 = 0.15;
    double v2 = v1 * m1 / m2;
    Offset centerOfMass = Offset(size.width / 2, size.height / 2);

    Point p1 = Point(
      parentSize: size,
      mass: m1,
      pos: centerOfMass + Offset(r1, 0),
      vel: Offset(0, v1),
    );

    Point p2 = Point(
      parentSize: size,
      pos: centerOfMass + Offset(-r2, 0),
      vel: Offset(0, -v2),
      mass: m2,
    );

    addChild(p1);
    addChild(p2);
  }

  void _updateFps(double dt) {
    if (dt != 0) {
      _avgFps *= _fpsSeen;
      if (_fpsSeen < _maxFpsSeen)
        _fpsSeen += 1;
      else
        _avgFps = _avgFps - (_avgFps / _fpsSeen);
      _avgFps += (1 / dt);
      _avgFps = _avgFps / _fpsSeen;
    }
  }

  Point _getPoint(int index) {
    if (!(children[index] is Point)) return null;
    return children[index];
  }

  void _fixFps() {
    if (0 >= children.length) return;
    if (_fpsSeen < _maxFpsSeen || _avgFps > _minFps || children.length < 10)
      return;

    for (int i = 0; i < (_minFps - _avgFps) / 2; i++) _killPoint();
    _tickToastTimer = true;
    _fpsSeen = 0;
    _avgFps = 0;
  }

  void _killPoint() {
    int index = 0;
    Point point = _getPoint(index);

    while (!(point != null && !point.isDying)) {
      index += 1;
      if (index >= children.length) break;

      point = _getPoint(index);
    }

    point.kill();
    _numRecentlyKilled += 1;
  }

  void _updateToast() {
    if (!_tickToastTimer) return;
    _toastTimer += 1;
    if (_toastTimer >= _framesBeforeToast) {
      _toastTimer = 0;
      _tickToastTimer = false;

      print("Deleted ${_numRecentlyKilled.round()} Points");
      print("There are now ${children.length} points");
      /* SHOW A "TOAST" EVERY TIME IT DELETES POINTS
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text("Deleted ${_numRecentlyKilled.round()} Points to preserve FPS"),
      ));
      */
      _numRecentlyKilled = 0;
    }
  }

  void _atract() {
    for (Node node1 in children) {
      if (!(node1 is Point)) continue;
      for (Node node2 in children) {
        if (!(node2 is Point)) continue;
        Point point1 = node1;
        Point point2 = node2;
        point1.attract(point2, g);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _updateFps(dt);
    _fixFps();
    _updateToast();

    for (int i = children.length - 1; i >= 0; i--) {
      Point point;
      if (children[i] is Point) {
        point = children[i];
        if (point.isDead) children.removeAt(i);
      }
    }

    _atract();

    if (mode == Modes.Gravity) {
      for (Map<String, dynamic> pointer in _pointersPos) {
        for (Node node in children) {
          if (!(node is Point)) continue;
          Point point = node;
          point.attractFinger(pointer["pos"], g);
        }
      }
      return;
    }

    if (mode == Modes.Repel) {
      for (Map<String, dynamic> pointer in _pointersPos) {
        for (Node node in children) {
          if (!(node is Point)) continue;
          Point point = node;
          point.repelFinger(pointer["pos"], g);
        }
      }
      return;
    }

    if (mode == Modes.Add) {
      for (Map<String, dynamic> pointer in _pointersPos)
        _addPoints(_addPointDensity * dt, pointer);
      return;
    }
  }

  void _addPoints(double amount, Map<String, dynamic> pointer) {
    if (pointer["remainder"] >= 1) {
      pointer["remainder"]--;
      amount++;
    }
    for (int i = 0; i < amount; i++) if (amount >= 1) _addPoint(pointer["pos"]);
    double remain = amount - amount.floor();
    pointer["remainder"] += remain;
  }

  void _addPoint(Offset position) {
    math.Random random = math.Random();
    double a = random.nextDouble() * math.pi * 2;
    double r = random.nextDouble() * _pointsSpread;
    Offset shake = Offset(r * math.cos(a), r * math.sin(a));
    addChild(
      Point(
        parentSize: size,
        pos: position + shake,
      ),
    );
  }

  void setMode(Modes newMode) {
    mode = newMode;
  }

  void reset() {
    children.clear();
    _addStarterPoints();
  }

  void setGravity(double newG) => g = newG;

  void setContext(BuildContext newContext) => context = newContext;

  double get gravity => g;

  List<Map<String, dynamic>> _pointersPos = List();
  @override
  bool handleEvent(SpriteBoxEvent event) {
    if (event.type == PointerDownEvent) {
      Map<String, dynamic> newValue = {
        "id": event.pointer,
        "pos": event.boxPosition,
        "remainder": 0,
      };
      _pointersPos.add(newValue);
      return true;
    }

    if (event.type == PointerMoveEvent) {
      int index = _pointersPos.indexWhere(
          (Map<String, dynamic> pointer) => pointer["id"] == event.pointer);
      _pointersPos[index]["pos"] = event.boxPosition;
      return true;
    }

    if (event.type == PointerUpEvent || event.type == PointerCancelEvent) {
      _pointersPos.removeWhere(
          (Map<String, dynamic> pointer) => pointer["id"] == event.pointer);
      return true;
    }

    return true;
  }
}
