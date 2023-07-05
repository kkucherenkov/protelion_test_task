import 'package:flutter/material.dart';
import 'package:protelion_test_task/utils/utils.dart';
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
  final GlobalKey<AnimatedListState> _listKey =
      GlobalKey(debugLabel: 'animatedList');

  @override
  void initState() {
    super.initState();
  }

  void addElement((int id, Color color) value) {
    int index = findIndexToInsert(_colors, value.$1);
    _colors.insert(index, value);
    final duration = getIntInRange(200, 500);
    _listKey.currentState
        ?.insertItem(index, duration: Duration(milliseconds: duration));
    final currentIndex = (_scrollController.offset / itemHeight).ceil();
    if (index < currentIndex) {
      _scrollController.jumpTo(_scrollController.offset + itemHeight);
    }
  }

  Widget _itemBuilder(BuildContext context, int index, animation) {
    var item = _colors[index];
    TextStyle? textStyle = Theme.of(context).textTheme.headlineSmall;
    final screenWidth = MediaQuery.of(context).size.width;
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: Container(
        height: itemHeight,
        width: screenWidth,
        color: item.$2,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${item.$1}',
              style: textStyle,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      controller: _scrollController,
      physics: const PositionRetainedScrollPhysics(),
      itemBuilder: _itemBuilder,
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
