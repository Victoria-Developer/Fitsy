import 'package:fitsy/presentation/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../navigation/app_navigator.dart';
import '../../domain/models/route.dart';

class DynamicBottomBar extends ConsumerStatefulWidget {
  const DynamicBottomBar({super.key});

  @override
  ConsumerState<DynamicBottomBar> createState() => _DynamicBottomBarState();
}

class _DynamicBottomBarState extends ConsumerState<DynamicBottomBar> {
  List<NavRoute> routes = [generatorRoute, settingsRoute];

  @override
  Widget build(BuildContext context) {
    final currentPath = ref.watch(routerProvider).state?.path;

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
              routes, currentPath, (route) {
                if(context.canPop()) {
                  context.pop();
                }
                context.push(route.path);
              }),
        ),
      ),
    );
  }

  List<Widget> _buildButtons(List<NavRoute> routes, String? currentRoute,
      void Function(NavRoute) onPressed) {
    List<Widget> buttons = [];
    for (var route in routes) {
      Widget icon = route.icon ?? const Icon(Icons.accessibility_sharp);
      final button = IconButton(
          icon: icon,
          iconSize: 30.0,
          isSelected: currentRoute == route.path,
          onPressed: () => onPressed(route));
      buttons.add(button);
    }
    return buttons;
  }
}
