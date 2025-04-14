import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  Size get canvasSize => MediaQuery.sizeOf(context);
  final random = Random();

  late List<Particle> particles = List.generate(100, _particleGenerator);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: CustomPaint(
          painter: Particles(
            repaint: controller,
            particles: particles,
            size: MediaQuery.sizeOf(context),
          ),
        ),
      ),
    );
  }

  Particle _particleGenerator(_) {
    final size = random.nextDouble() * 5 + 1;
    final x = (random.nextDouble() * ((canvasSize.width  - size * 2) - (size * 2)) + size * 2);
    final y = (random.nextDouble() * ((canvasSize.height - size * 2) - (size * 2)) + size * 2);
    final directX = (random.nextDouble() * 5) - 2.5;
    final directY = (random.nextDouble() * 5) - 2.5;
    final color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    return Particle()
      ..x = x
      ..y = y
      ..directX = directX
      ..directY = directY
      ..radius = size
      ..color = color
      ..paint.color = color;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}

class Particles extends CustomPainter {

  final Size size;
  final List<Particle> particles;

  Particles({super.repaint, required this.size, required this.particles});

  final _edgePaint = Paint()..strokeWidth = 1;

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle
        ..update(this.size)
        ..draw(canvas);
    }

    for (var i = 0; i < particles.length; i++) {
      for (var j = i ; j < particles.length; j++) {
        if (i == j) continue;
        final dx = particles[i].x - particles[j].x;
        final dy = particles[i].y - particles[j].y;
        final distance = sqrt(dx * dx + dy * dy);
        if (distance < 100) {
          canvas.drawLine(
            Offset(particles[i].x, particles[i].y),
            Offset(particles[j].x, particles[j].y),
            _edgePaint
              ..color = Colors.grey.withAlpha(
                (1 - (distance / 100) * 255).toInt(),
              )

          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}


class Particle {

  double x = 0;
  double y = 0;
  double directX = 0;
  double directY = 0;
  double radius = 0;
  Size size = Size.zero;
  Color color = Colors.red;

  Paint paint = Paint()
    ..color = Colors.red
    ..style = PaintingStyle.fill;

  void update(Size canvasSize) {

    x += directX;
    y += directY;

    if (x < radius || x > canvasSize.width - radius) {
      directX = -directX;
    }
    if (y < radius || y > canvasSize.height - radius) {
      directY = -directY;
    }

  }

  void draw(Canvas canvas) {
    canvas.drawCircle(
      Offset(x, y),
      radius,
      paint,
    );
  }

}