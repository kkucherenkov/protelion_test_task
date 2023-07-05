import 'dart:math';
import 'dart:ui';

int getIntInRange(int min, int max) {
  return Random().nextInt(max - min) + min;
}

(int id, Color color) generateColorPair(int maxId) {
  int id = Random().nextInt(maxId);
  int r = Random().nextInt(255);
  int g = Random().nextInt(255);
  int b = Random().nextInt(255);
  int a = Random().nextInt(200);
  Color color = Color.fromARGB(a, r, g, b);

  return (id, color);
}
