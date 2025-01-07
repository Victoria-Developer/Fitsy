import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DynamicBottomBar extends StatelessWidget {
  const DynamicBottomBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

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
            _buildIconButton(const Icon(Icons.settings), 1),
          ],
        ),
      ),
    );
  }

  IconButton _buildIconButton(Icon icon, int index) {
    return IconButton(
      icon: icon,
      iconSize: 30.0,
      isSelected: navigationShell.currentIndex == index,
      onPressed: () {
        navigationShell.goBranch(
          index,
          initialLocation:
          index == navigationShell.currentIndex,
        );
      }
    );
  }
}
