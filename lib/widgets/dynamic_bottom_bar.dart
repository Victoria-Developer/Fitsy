import 'package:flutter/material.dart';

class DynamicBottomBar extends StatefulWidget {
  const DynamicBottomBar(
      {super.key, required this.onNavigateToTab, required this.currentTabId});

  final void Function(int) onNavigateToTab;
  final int currentTabId;

  @override
  State<DynamicBottomBar> createState() => _DynamicBottomBarState();
}

class _DynamicBottomBarState extends State<DynamicBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildIconButton(const Icon(Icons.home), 0),
            _buildIconButton(const Icon(Icons.access_time), 1),
          ],
        ),
      ),
    );
  }

  IconButton _buildIconButton(Icon icon, int index) {
    const unselectedItemColor = Colors.black54;
    const selectedItemColor = Colors.amber;

    return IconButton(
      icon: icon,
      iconSize: 30.0,
      onPressed: () {
        widget.onNavigateToTab(index);
      },
      color: widget.currentTabId == index
          ? selectedItemColor
          : unselectedItemColor,
    );
  }
}
