

import 'dart:ui';

Color mixColors(Color first, Color second, {double t = 0.5}) {
  final r = (first.red * (1 - t) + second.red * t).toInt();
  final g = (first.green * (1 - t) + second.green * t).toInt();
  final b = (first.blue * (1 - t) + second.blue * t).toInt();
  final a = (first.alpha * (1 - t) + second.alpha * t).toInt();

  return Color.fromARGB(a, r, g, b);
}