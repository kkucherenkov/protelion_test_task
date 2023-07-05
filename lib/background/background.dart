import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

const maxItems = 1000;
const minItems = 25;
const maxDelay = 1000;
const minDelay = 50;

void colorPairsGenerator(SendPort sendPort) {
  ReceivePort isolateReceivePort = ReceivePort();
  sendPort.send(isolateReceivePort.sendPort);
  isolateReceivePort.listen((message) {
    if (message == 'start') {
      if (kDebugMode) {
        print('start');
      }
      final int numberOfPairs = getIntInRange(minItems, maxItems);
      for (int i = 0; i < numberOfPairs; i++) {
        final delay = getIntInRange(minDelay, maxDelay);
        final pair = generateColorPair(numberOfPairs);
        sendPort.send(pair);
        sleep(Duration(milliseconds: delay));
      }
      sendPort.send('done');
    }
  });
}

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
