import 'package:flutter/material.dart';
import '../navigation/route.dart';

class DynamicBottomBar extends StatelessWidget {
  const DynamicBottomBar({
    super.key,
      required this.routes,
      required this.isSelected,
      required this.onNavigation
  });

  final List<NavRoute> routes;
  final bool Function(NavRoute route) isSelected;
  final void Function(BuildContext context, NavRoute route) onNavigation;

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
            for (int i = 0; i < routes.length; i++)
              _buildIconButton(context, routes[i]),
          ],
        ),
      ),
    );
  }

  IconButton _buildIconButton(context, NavRoute route) {
    Widget icon = route.icon ?? const Icon(Icons.insert_comment_sharp);
    return IconButton(
        icon: icon,
        iconSize: 30.0,
        isSelected: isSelected(route),
        onPressed: () => onNavigation(context, route));
  }
}
