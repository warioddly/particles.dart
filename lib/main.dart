import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particles/particle.dart';
import 'package:particles/particles_painter.dart';

const _particlesCount = 150;
const _particleSize = 5.0;
const _particleMaxSpeed = 5;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late List<Particle> particles = List.generate(_particlesCount, _particleGenerator);

  final random = Random();
  final mouseOffset = ValueNotifier(Offset.zero);

  Size get canvasSize => MediaQuery.sizeOf(context);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Particles',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: Listener(
          onPointerHover: (details) => mouseOffset.value = details.localPosition,
          onPointerDown: (details) {
            particles.add(
                _particleGenerator(null)
                    ..x = details.localPosition.dx
                    ..y = details.localPosition.dy
            );
          },
          child: CustomPaint(
            size: canvasSize,
            painter: Particles(
              repaint: controller,
              particles: particles,
              mouseOffset: mouseOffset,
            ),
          ),
        ),
      ),
    );
  }

  Particle _particleGenerator(_) {
    final size = random.nextDouble() * _particleSize + 1;
    final x = (random.nextDouble() * ((canvasSize.width  - size * 2) - (size * 2)) + size * 2);
    final y = (random.nextDouble() * ((canvasSize.height - size * 2) - (size * 2)) + size * 2);
    final vx = (random.nextDouble() * _particleMaxSpeed) - (_particleMaxSpeed / 2);
    final vy = (random.nextDouble() * _particleMaxSpeed) - (_particleMaxSpeed / 2);
    final color = Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
    return Particle()
      ..x = x
      ..y = y
      ..vx = vx
      ..vy = vy
      ..radius = size
      ..color = color;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}


