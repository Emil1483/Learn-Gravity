import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

import './point.dart';
import '../enums/modes.dart';
import '../ui_elements/mode_fab.dart';

class RootNode extends NodeWithSize {
  Modes mode = Modes.Nothing;
  GlobalKey<ModeFabState> _modeFabKey;

  final double _pointsSpread = 30;
  final double _addPointDensity = 15;
  final double minG = -2.5;
  final double maxG = 5;
  double g = 1.5;
  final int _maxFpsSeen = 5;
  final double _minFps = 50;
  final double _framesBeforeToast = 200;
  final double _addPointWithSpeedMult = 0.1;

  double _numRecentlyKilled = 0;
  double _toastTimer = 0;
  bool _tickToastTimer = false;
  double _avgFps = 0;
  int _fpsSeen = 0;
  Function onTapped;

  //TODO: Make a tutorial for when the user unlocks the app

  RootNode({@required Size size}) : super(size) {
    assert(size != null);

    print("new rootNode with: $size");

    userInteractionEnabled = true;
    handleMultiplePointers = true;

    _addStarterPoints();
  }

  void setOnTappedFunction(Function f) {
    onTapped = f;
  }

  void setSize(Size size) {
    this.size = size;
    reset();
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
  SpriteBox get spriteBox => SpriteBox(this);

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

    if (_pointersPos.length > 0 && onTapped != null) if (!onTapped()) return;

    mode = _modeFabKey.currentState.mode;

    switch (mode) {
      case Modes.Nothing:
        break;

      case Modes.Gravity:
        for (Map<String, dynamic> pointer in _pointersPos) {
          for (Node node in children) {
            if (!(node is Point)) continue;
            Point point = node;
            point.attractFinger(pointer["pos"], g);
          }
        }
        break;

      case Modes.Repel:
        for (Map<String, dynamic> pointer in _pointersPos) {
          for (Node node in children) {
            if (!(node is Point)) continue;
            Point point = node;
            point.repelFinger(pointer["pos"], g);
          }
        }
        break;

      case Modes.Add:
        for (Map<String, dynamic> pointer in _pointersPos)
          _addPoints(_addPointDensity * dt, pointer);
        break;

      case Modes.Negative:
        for (Map<String, dynamic> pointer in _pointersPos)
          _addPoints(_addPointDensity * dt, pointer, negative: true);
        break;
      case Modes.Move:
        for (Map<String, dynamic> pointer in _pointersPos) {
          if (pointer["touchedChild"] != null &&
              pointer["touchedChild"] is Point) {
            Point point = pointer["touchedChild"];
            point.moveBy(pointer["pos"] - pointer["pPos"]);
            pointer["ppPos"] = pointer["pPos"];
            pointer["pPos"] = pointer["pos"];

            point.cancelVel();
          }
        }
        break;
      case Modes.AddWithVel:
        break;
    }
  }

  @override
  void paint(Canvas canvas) {
    super.paint(canvas);
    if (mode == Modes.AddWithVel) {
      Paint paint = Paint();
      paint.strokeWidth = 5;
      paint.color = Colors.white;
      paint.strokeCap = StrokeCap.round;

      for (Map<String, dynamic> pointer in _pointersPos) {
        paintArrow(canvas, paint, pointer["pos"], pointer["startPos"]);
      }
    }
  }

  void paintArrow(Canvas canvas, Paint paint, Offset start, Offset end) {
    if ((start - end).distance <= 5) return;

    canvas.drawLine(start, end, paint);

    double angle = (start - end).direction;

    double angleDiff = math.pi / 7;
    double endLineLength = 15;

    Offset endLine1 = Offset.fromDirection(angle + angleDiff);
    Offset endLine2 = Offset.fromDirection(angle - angleDiff);
    endLine1 *= endLineLength;
    endLine2 *= endLineLength;
    endLine1 += end;
    endLine2 += end;

    canvas.drawLine(end, endLine1, paint);
    canvas.drawLine(end, endLine2, paint);
  }

  void _addPoints(double amount, Map<String, dynamic> pointer,
      {negative = false}) {
    if (pointer["remainder"] >= 1) {
      pointer["remainder"]--;
      amount++;
    }
    for (int i = 0; i < amount; i++)
      if (amount >= 1) _addPoint(pointer["pos"], negative: negative);
    double remain = amount - amount.floor();
    pointer["remainder"] += remain;
  }

  void _addPoint(Offset position,
      {bool negative = false, bool addSpread = true, Offset vel}) {
    math.Random random = math.Random();
    double a = random.nextDouble() * math.pi * 2;
    double r = random.nextDouble() * _pointsSpread;
    Offset shake = Offset(r * math.cos(a), r * math.sin(a));
    addChild(
      Point(
        parentSize: size,
        pos: position + (addSpread ? shake : Offset.zero),
        negative: negative,
        vel: vel != null ? vel : Offset.zero,
      ),
    );
  }

  void setMode(Modes newMode) {
    mode = newMode;
    print("current mode is $mode");
  }

  void setModeFabKey(GlobalKey<ModeFabState> key) => _modeFabKey = key;

  void reset() {
    children.clear();
    _addStarterPoints();
  }

  void setGravity(double newG) => g = newG;

  double get gravity => g;

  Map<String, dynamic> _getPointerById(int id) {
    return _pointersPos.firstWhere(
      (Map<String, dynamic> pointer) => pointer["id"] == id,
    );
  }

  List<Map<String, dynamic>> _pointersPos = List();
  @override
  bool handleEvent(SpriteBoxEvent event) {
    if (event.type == PointerDownEvent) {
      Map<String, dynamic> newValue = {
        "id": event.pointer,
        "pos": event.boxPosition,
        "pPos": event.boxPosition,
        "ppPos": event.boxPosition,
        "startPos": event.boxPosition,
        "touchedChild": children.lastWhere(
          (Node node) => node.isPointInside(event.boxPosition),
          orElse: () => null,
        ),
        "remainder": 0,
      };
      _pointersPos.add(newValue);
      return true;
    }

    if (event.type == PointerMoveEvent) {
      _getPointerById(event.pointer)["pos"] = event.boxPosition;
      return true;
    }

    if (event.type == PointerUpEvent || event.type == PointerCancelEvent) {
      Map<String, dynamic> pointer = _getPointerById(event.pointer);
      if (mode == Modes.Move) {
        _throwPointWithPointer(
          pointer: pointer,
          event: event,
        );
      } else if (mode == Modes.AddWithVel) {
        _addPoint(
          pointer["pos"],
          addSpread: false,
          vel: (pointer["startPos"] - pointer["pos"]) * _addPointWithSpeedMult,
        );
      }

      _pointersPos.remove(pointer);
      return true;
    }

    return true;
  }

  void _throwPointWithPointer({
    Map<String, dynamic> pointer,
    SpriteBoxEvent event,
  }) {
    Node node = pointer["touchedChild"];
    if (node == null || !(node is Point)) return;

    Point point = node;
    bool shouldUsePpPos = (event.boxPosition - pointer["pPos"]).distance == 0;
    Offset pPos = shouldUsePpPos ? pointer["ppPos"] : pointer["pPos"];
    point.setVel(event.boxPosition - pPos);
  }
}
