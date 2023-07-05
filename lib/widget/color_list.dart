import 'package:flutter/material.dart';
import 'package:protelion_test_task/widget/positional_scroll_physics.dart';

const itemHeight = 50.0;

class ColorList extends StatefulWidget {
  const ColorList({super.key});

  @override
  State<StatefulWidget> createState() {
    return ColorListState();
  }
}

class ColorListState extends State<ColorList> {
  final List<(int id, Color color)> _colors = [];
  final ScrollController _scrollController = ScrollController();

  double _screenWidth = 0;

  @override
  void initState() {
    super.initState();
  }

  void addElement((int id, Color color) value) {
    int index = findIndexToInsert(_colors, value.$1);
    setState(() {
      _colors.insert(index, value);
    });

    final currentIndex = (_scrollController.offset / itemHeight).ceil();
    if (index <= currentIndex) {
      _scrollController.jumpTo(_scrollController.offset + itemHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      controller: _scrollController,
      physics: const PositionRetainedScrollPhysics(),
      itemExtent: itemHeight,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: itemHeight,
          width: _screenWidth,
          color: _colors[index].$2,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${_colors[index].$1}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        );
      },
      itemCount: _colors.length,
    );
  }

  int findIndexToInsert(List<(int, Color)> colors, int id) {
    if (colors.isEmpty) {
      return 0;
    } else {
      int start = 0;
      int end = colors.length - 1;
      while (start <= end) {
        int mid = ((start + end) / 2).floor();
        if (colors[mid].$1 == id) {
          return mid;
        } else if (colors[mid].$1 < id) {
          start = mid + 1;
        } else {
          end = mid - 1;
        }
      }
      return end + 1;
    }
  }
}
