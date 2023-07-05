import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protelion_test_task/constants.dart';
import 'package:protelion_test_task/utils/utils.dart';

enum IsolateStatus { initial, ready, receiveNewData, done }

sealed class IsolateEvent {}
class StartIsolate extends IsolateEvent {}
class StartComputing extends IsolateEvent {}
class FinishComputation extends IsolateEvent {}
class ReceivedData extends IsolateEvent {
  ReceivedData(this.data);
  (int, Color) data;
}

final class IsolateState {
  const IsolateState({
    this.status = IsolateStatus.initial,
    this.color,
  });

  final IsolateStatus status;
  final (int, Color)? color;


  IsolateState copyWith({
    IsolateStatus? newStatus,
    (int, Color)? newColor,
  }) {
    return IsolateState(
      status: newStatus ?? status,
      color: newColor ?? color,
    );
  }
}

class IsolateBloc extends Bloc<IsolateEvent, IsolateState> {
  ReceivePort? _receivePort;
  SendPort? _mainToIsolateStream;
  Isolate? _isolate;

  IsolateBloc() : super(const IsolateState()) {
    on<StartIsolate>(spawnIsolate);
    on<StartComputing>((event, emit) => _mainToIsolateStream?.send(IsolateCommands.start));
    on<ReceivedData>((event, emit) => emit(state.copyWith(newStatus: IsolateStatus.receiveNewData, newColor: event.data)));
    on<FinishComputation>((event, emit) => emit(state.copyWith(newStatus: IsolateStatus.done, newColor: null)));
  }




  Future spawnIsolate(StartIsolate event, Emitter<IsolateState> emit) async {
    _receivePort = ReceivePort();
    _isolate = await Isolate.spawn(colorPairsGenerator, _receivePort!.sendPort,
        debugName: 'colorPairsGenerator');
    emit(state.copyWith(newStatus: IsolateStatus.ready));
    handle(emit);
  }

  void handle(Emitter<IsolateState> emit) {
    _receivePort?.listen((data) {
      if (data is SendPort) {
        _mainToIsolateStream = data;
      } else if (data is (int, Color)) {
        add(ReceivedData(data));
      } else if (data == IsolateCommands.done) {
        add(FinishComputation());
      }
    });
  }

  static void colorPairsGenerator(SendPort sendPort) {
    ReceivePort isolateReceivePort = ReceivePort();
    sendPort.send(isolateReceivePort.sendPort);
    isolateReceivePort.listen((message) {
      if (message == IsolateCommands.start) {
        debugPrint('start');
        final int numberOfPairs = getIntInRange(minItems, maxItems);
        for (int i = 0; i < numberOfPairs; i++) {
          final delay = getIntInRange(minDelay, maxDelay);
          final pair = generateColorPair(numberOfPairs);
          sendPort.send(pair);
          sleep(Duration(milliseconds: delay));
        }
        sendPort.send(IsolateCommands.done);
      }
    });
  }

  @override
  Future<void> close() async {
    if (_isolate != null) {
      _isolate!.kill();
    }
    return super.close();
  }
}