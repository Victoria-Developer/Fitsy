import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: changeTab,
        backgroundColor: const Color(0xffe0b9f6),
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Plans')
        ],
      ),
    );
  }

  void popUntilPath(String routePath) {
    final router = GoRouter.of(context);
    final GoRouterDelegate delegate = router.routerDelegate;
    List routeStacks = [...delegate.currentConfiguration.routes];

    bool pathExists = routeStacks.any((route) {
      return route is GoRoute && route.name == routePath;
    });

    if (!pathExists) {
      router.push(routePath);
      return;
    }

    for (int i = routeStacks.length - 1; i >= 0; i--) {
      RouteBase route = routeStacks[i];
      if (route is GoRoute) {
        if (route.name == routePath) break;
        if (i != 0 && routeStacks[i - 1] is ShellRoute) {
          RouteMatchList matchList = delegate.currentConfiguration;
          router.restore(matchList.remove(matchList.matches.last));
        } else {
          router.pop();
        }
      }
    }
  }

  void changeTab(int index) {
    switch (index) {
      case 0:
        popUntilPath('/');
        break;
      case 1:
        popUntilPath('/plans');
        break;
      default:
        context.go('/');
        break;
    }
    setState(() {
      currentIndex = index;
    });
  }
}
