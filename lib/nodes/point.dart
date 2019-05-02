import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:spritewidget/spritewidget.dart';

class Point extends Node {
  final Size parentSize;

  final double _padding = 35;
  final double _minSize = 5;
  final double _maxSize = 15;
  final double _colorVariety = 150;
  final double _amountOfBlue = 0.6;
  final double _distanceMult = 1;
  final double _dampening = 1;
  final double _maxSpeed = 7;
  final double _speedDampening = 0.95;
  final double _trailLength = 10;
  final double _trailSpacing = 1;
  final double _trailAlpha = 50;
  final double _fingerMass = 1500;
  final double _timeBeforeDeath = 1;

  double _deathTimer = 0;
  bool _dead = false;
  double _maxSpeedSq;
  double _currentTrail = 0;
  Color _color;
  double _radius;
  List<Offset> trail = List<Offset>();
  Offset _vel = Offset(0, 0);
  Offset _acc = Offset(0, 0);

  Point({@required this.parentSize, Offset pos, Offset vel, double mass}) {
    assert(parentSize != null);

    math.Random random = math.Random();

    if (vel != null) _vel = vel;

    if (pos != null)
      this.position = pos;
    else {
      final double w = parentSize.width + _padding * 2;
      final double h = parentSize.height + _padding * 2;
      this.position = Offset(
        random.nextDouble() * w - _padding,
        random.nextDouble() * h - _padding,
      );
    }

    _color = random.nextDouble() > _amountOfBlue
        ? Colors.white
        : Color.fromARGB(
            255, 0, 255 - (random.nextDouble() * _colorVariety).round(), 255);

    if (mass != null)
      _radius = mass;
    else
      _radius = random.nextDouble() * (_maxSize - _minSize) + _minSize;

    _maxSpeedSq = _maxSpeed * _maxSpeed;
  }

  get isDead => _deathTimer >= _timeBeforeDeath;

  get isDying => _dead;

  void kill() {
    _dead = true;
  }

  get radius {
    return _radius;
  }

  get mass {
    return _radius;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_currentTrail % _trailSpacing == 0) {
      trail.add(position);
      if (trail.length > _trailLength) trail.removeAt(0);
    }
    _currentTrail += 1;

    _vel += _acc;
    limitSpeed();
    position += _vel * dt * 60;

    _acc *= 0.0;

    _edges();

    if (_dead) _deathTimer += dt;
  }

  void _edges() {
    double x = position.dx;
    double y = position.dy;
    double width = parentSize.width;
    double height = parentSize.height;
    if (x + radius >= width + _padding)
      _vel -= Offset(_vel.dx + _vel.dx * _dampening, 0);
    if (x - radius <= -_padding)
      _vel -= Offset(_vel.dx + _vel.dx * _dampening, 0);
    if (y + radius >= height + _padding)
      _vel -= Offset(0, _vel.dy + _vel.dy * _dampening);
    if (y - radius <= -_padding)
      _vel -= Offset(0, _vel.dy + _vel.dy * _dampening);
  }

  void limitSpeed() {
    double speed = _vel.distanceSquared;
    if (speed > _maxSpeedSq) _vel *= _speedDampening;
  }

  void _applyForce(Offset force) {
    _acc += force / _radius;
  }

  Offset _getGravForce(Offset pos, double r, double mass, double g) {
    double minDistanceSquared = (this.radius + r) * (this.radius + r);

    Offset force = pos - this.position;
    double distanceSquared = force.distanceSquared;

    if (distanceSquared < minDistanceSquared) return null;

    distanceSquared *= _distanceMult;

    force = Offset.fromDirection(force.direction);

    double mag = g * (this._radius + mass) / distanceSquared;
    force *= mag;

    return force;
  }

  void attract(Point point, double g) {
    if (point == this) return;

    Offset force = _getGravForce(point.position, point.radius, point.mass, g);

    if (force == null) return;
    _applyForce(force);
  }

  void attractFinger(Offset pos, double g) {
    Offset force = _getGravForce(pos, 0, _fingerMass, g);
    if (force == null) return;

    _applyForce(force);
  }

  void repelFinger(Offset pos, double g) {
    Offset force = _getGravForce(pos, 0, _fingerMass, g);
    if (force == null) return;

    _applyForce(-force);
  }

  void paintTrail(Canvas canvas) {
    Paint paint = Paint();

    for (int i = 0; i < trail.length - 1; i++) {
      final double m = 1 - (_deathTimer / _timeBeforeDeath);
      final double fraction = i / (_trailLength - 1);
      final int alpha = (_trailAlpha * fraction * m).round();
      paint.color = _color.withAlpha(alpha);
      paint.strokeWidth = fraction * _radius * 2;
      paint.strokeCap = StrokeCap.round;

      canvas.drawLine(trail[i] - position, trail[i + 1] - position, paint);
    }
  }

  @override
  void paint(Canvas canvas) {
    if (_deathTimer > _timeBeforeDeath) return;
    final double m = 1 - (_deathTimer / _timeBeforeDeath);
    final int alpha = (m * 255).round();

    Paint paint = Paint();
    paint.color = _color.withAlpha(alpha);

    canvas.drawCircle(Offset.zero, _radius * m, paint);

    paint.style = PaintingStyle.stroke;

    //paintTrail(canvas);
  }
}
