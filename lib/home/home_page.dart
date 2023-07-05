import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:protelion_test_task/widget/color_list.dart';

import '../background/background.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ReceivePort? _receivePort;
  Isolate? _isolate;
  SendPort? _mainToIsolateStream;
  final colorListKey = GlobalKey<ColorListState>();

  void _onFloatingButtonPressed() {
    _mainToIsolateStream?.send('start');
  }

  @override
  void initState() {
    spawnIsolate();
    super.initState();
  }

  @override
  void dispose() {
    if (_isolate != null) {
      _isolate!.kill();
    }
    super.dispose();
  }

  Future spawnIsolate() async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(colorPairsGenerator, _receivePort!.sendPort,
        debugName: "colorPairsGenerator");
    _receivePort?.listen((data) {
      if (data is SendPort) {
        _mainToIsolateStream = data;
      } else if (data is (int, Color)) {
        colorListKey.currentState?.addElement(data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: ColorList(key: colorListKey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingButtonPressed,
        tooltip: 'Start',
        child: const Icon(Icons.add),
      ),
    );
  }
}