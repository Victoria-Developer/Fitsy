import 'package:fitsy/presentation/navigation/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/settings_repository.dart';
import '../screens/options_page.dart';
import '../screens/recipes_page.dart';
import '../widgets/dynamic_bottom_bar.dart';

class AppNavigator {
  static final AppNavigator _instance = AppNavigator._internal();

  static AppNavigator get instance => _instance;

  late GoRouter router;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  final recipesRoute = NavRoute(id: 0, path: "/recipes", name: "recipes");
  final optionsRoute = NavRoute(id: 1, path: "/options", name: "options");

  AppNavigator._internal() {
    final settingsRepository = SettingsRepository.instance;
    final routes = <NavRoute>[recipesRoute, optionsRoute];
    bool isFirstLaunch = settingsRepository.isFirstLaunch;

    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: isFirstLaunch ? optionsRoute.path : recipesRoute.path,
      routes: [
        GoRoute(
          name: optionsRoute.name,
          path: optionsRoute.path,
          builder: (context, state) {
            final child = OptionsPage(
                onNavigateToPlanGeneratorPage: (days, calories, budget) {
                  router.pushNamed(recipesRoute.name, extra: {
                    "days": "$days",
                    "calories": "$calories",
                    "budget": "$budget"
                  });
                  if (isFirstLaunch) {
                    isFirstLaunch = false;
                  }
                },
                title: 'Options');
            return isFirstLaunch
                ? child
                : _buildScreenWithStaticBottomBar(
                    state, routes, child, optionsRoute.id);
          },
        ),
        GoRoute(
          name: recipesRoute.name,
          path: recipesRoute.path, //:days/:calories/:budget
          builder: (context, state) {
            final extra = state.extra as Map<String, String>?;
            final days =
                int.tryParse(extra?['days'] ?? '') ?? settingsRepository.days;
            final calories = int.tryParse(extra?['calories'] ?? '') ??
                settingsRepository.calories;
            final budget = int.tryParse(extra?['budget'] ?? '') ??
                settingsRepository.budget;

            final child = RecipesPage(
                title: 'Recipes',
                days: days,
                calories: calories,
                budget: budget);
            return _buildScreenWithStaticBottomBar(
                state, routes, child, recipesRoute.id);
          },
        ),
        //]),
      ],
    );
  }

  Widget _buildScreenWithStaticBottomBar(state, routes, child, index) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: DynamicBottomBar(
          onNavigateToTab: onNavigateToTab, currentTabId: index),
    );
  }

  void popUntilPath(String routePath) {
    final GoRouterDelegate delegate = router.routerDelegate;
    List routeStacks = [...delegate.currentConfiguration.routes];

    bool pathExists = routeStacks.any((route) {
      return route is GoRoute && route.path == routePath;
    });

    if (!pathExists) {
      router.push(routePath);
      return;
    }

    for (int i = routeStacks.length - 1; i >= 0; i--) {
      RouteBase route = routeStacks[i];
      if (route is GoRoute) {
        if (route.path == routePath) break;
        if (i != 0 && routeStacks[i - 1] is ShellRoute) {
          RouteMatchList matchList = delegate.currentConfiguration;
          router.restore(matchList.remove(matchList.matches.last));
        } else {
          router.pop();
        }
      }
    }
  }

  void onNavigateToTab(int index) {
    switch (index) {
      case 0:
        popUntilPath(recipesRoute.path);
        break;
      case 1:
        popUntilPath(optionsRoute.path);
        break;
      default:
        router.go(optionsRoute.path);
        break;
    }
  }
}
