import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:flutter/material.dart' show CustomPainter, Paint;
import 'package:particles/particle.dart';
import 'package:particles/utils.dart';

const _edgeDistance = 100.0;

class Particles extends CustomPainter {
  final List<Particle> particles;
  final ValueNotifier<Offset> mouseOffset;

  Particles({
    super.repaint,
    required this.particles,
    required this.mouseOffset,
  });

  final _edgePaint = Paint()..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {

    final mouseOffset = this.mouseOffset.value;

    for (var particle in particles) {
      particle
        ..update(size, mouseOffset)
        ..draw(canvas);
    }

    for (var i = 0; i < particles.length; i++) {
      for (var j = i; j < particles.length; j++) {
        if (i == j) continue;
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distance = sqrt(dx * dx + dy * dy);
        if (distance < _edgeDistance) {
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            _edgePaint
              ..color = mixColors(particles[i].color, particles[j].color).withAlpha(
              (1 - (distance / _edgeDistance) * 255).toInt(),
            )
          );
        }
      }
    }

  }

  @override
  bool shouldRepaint(covariant Particles oldDelegate) {
    return oldDelegate.particles.length != particles.length ||
      oldDelegate.mouseOffset.value != mouseOffset.value;
  }
}
