import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart' show Colors;

class Particle {

  double x = 0;
  double y = 0;
  double vx = 0;
  double vy = 0;
  double radius = 0;

  final _paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  set color(Color color) => _paint.color = color;

  Color get color => _paint.color;

  void update(Size canvasSize, [Offset mouseOffset = Offset.zero]) {

    x += vx;
    y += vy;

    final dx = x - mouseOffset.dx;
    final dy = y - mouseOffset.dy;
    final distance = sqrt(dx * dx + dy * dy);

    if (distance < 100) {
      final forceX = dx / distance;
      final forceY = dy / distance;

      final maxSpeed = 2.5;
      vx += forceX * 0.5;
      vy += forceY * 0.5;

      final speed = sqrt(vx * vx + vy * vy);
      if (speed > maxSpeed) {
        final scale = maxSpeed / speed;
        vx *= scale;
        vy *= scale;
      }
    }

    if (x < radius || x > canvasSize.width - radius) {
      vx = -vx;
    }
    if (y < radius || y > canvasSize.height - radius) {
      vy = -vy;
    }


  }

  void draw(Canvas canvas) {
    canvas.drawCircle(
      Offset(x, y),
      radius,
      _paint,
    );
  }

}