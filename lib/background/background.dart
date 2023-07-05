import 'dart:io';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:protelion_test_task/constants.dart';
import 'package:protelion_test_task/utils/utils.dart';

void colorPairsGenerator(SendPort sendPort) {
  ReceivePort isolateReceivePort = ReceivePort();
  sendPort.send(isolateReceivePort.sendPort);
  isolateReceivePort.listen((message) {
    if (message == IsolateCommand.start) {
      debugPrint('start');
      final int numberOfPairs = getIntInRange(minItems, maxItems);
      for (int i = 0; i < numberOfPairs; i++) {
        final delay = getIntInRange(minDelay, maxDelay);
        final pair = generateColorPair(numberOfPairs);
        sendPort.send(pair);
        sleep(Duration(milliseconds: delay));
      }
      sendPort.send(IsolateCommand.done);
    }
  });
}
