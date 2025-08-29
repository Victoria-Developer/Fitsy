import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../navigation/app_navigator.dart';
import '../navigation/route.dart';

class DynamicBottomBar extends ConsumerStatefulWidget {
  const DynamicBottomBar({
    super.key,
    required this.routes,
  });

  final List<NavRoute> routes;

  @override
  ConsumerState<DynamicBottomBar> createState() => _DynamicBottomBarState();
}

class _DynamicBottomBarState extends ConsumerState<DynamicBottomBar> {
  @override
  Widget build(BuildContext context) {
    final currentRoute = ref.watch(navigationProvider);
    final notifier = ref.read(navigationProvider.notifier);
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5.0,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildButtons(
              widget.routes, currentRoute, (route) => notifier.setRoute(route)),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(List<NavRoute> routes, NavRoute currentRoute,
      void Function(NavRoute) onPressed) {
    List<Widget> buttons = [];
    for (var route in routes) {
      Widget icon = route.icon ?? const Icon(Icons.insert_comment_sharp);
      final button = IconButton(
          icon: icon,
          iconSize: 30.0,
          isSelected: currentRoute == route,
          onPressed: () => onPressed(route));
      buttons.add(button);
    }
    return buttons;
  }
}