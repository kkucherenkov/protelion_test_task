import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protelion_test_task/home/bloc/isolate_bloc.dart';
import 'package:protelion_test_task/widget/color_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _colorListKey = GlobalKey<ColorListState>();

  @override
  void initState() {
    context.read<IsolateBloc>().add(StartIsolate());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IsolateBloc, IsolateState>(
        builder: (BuildContext context, IsolateState state) {
      Widget child;
      bool fbActive = false;
      switch (state.status) {
        case IsolateStatus.initial:
          child = const Center(
            child: CircularProgressIndicator(),
          );
          fbActive = false;
          break;
        case IsolateStatus.ready:
          child = const Center(
            child: Text('Press Button to start'),
          );
          fbActive = true;
          break;
        case IsolateStatus.done:
          child = Center(
            child: ColorList(
              key: _colorListKey,
            ),
          );
          fbActive = true;
          break;
        default:
          child = Center(
            child: ColorList(
              key: _colorListKey,
            ),
          );
          fbActive = false;
          break;
      }
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: child,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fbActive
              ? () => context.read<IsolateBloc>().add(StartComputing())
              : null,
          tooltip: 'Start',
          child: const Icon(Icons.play_arrow),
        ),
      );
    }, listener: (BuildContext context, IsolateState state) {
      switch (state.status) {
        case IsolateStatus.receiveNewData:
          if (state.color != null) {
            _colorListKey.currentState?.addElement(state.color!);
          }
        case IsolateStatus.done:
        default:
          break;
      }
    });
  }
}
