import 'package:fitsy/navigation/route.dart';
import 'package:fitsy/widgets/dynamic_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_page.dart';
import '../screens/plans_page.dart';
import '../screens/recipes_page.dart';

class AppNavigator {
  static final AppNavigator _instance = AppNavigator._internal();

  static AppNavigator get instance => _instance;

  late GoRouter router;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();
  final _shellNavigatorKey = GlobalKey<NavigatorState>();

  final homeRoute = NavRoute(id: 0, path: "/", name: "home");
  final plansRoute = NavRoute(id: 1, path: "/plans", name: "plans");
  final recipesRoute = NavRoute(id: 2, path: "/recipes", name: "recipes");

  AppNavigator._internal() {
    final routes = <NavRoute>[homeRoute, recipesRoute, plansRoute];

    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: homeRoute.path,
      routes: [
        ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) {
              int index = routes
                  .firstWhere((route) => route.name == state.topRoute!.name,
                      orElse: () => routes[0])
                  .id;
              return Scaffold(
                body: child,
                bottomNavigationBar: DynamicBottomBar(
                    onNavigateToTab: onNavigateToTab, currentTabId: index),
              );
            },
            routes: [
              GoRoute(
                name: homeRoute.name,
                path: homeRoute.path,
                builder: (context, state) => HomePage(
                    onNavigateToRecipes: (days, calories, budget) {
                      router.pushNamed(recipesRoute.name, pathParameters: {
                        "days": "$days",
                        "calories": "$calories",
                        "budget": "$budget"
                      });
                      // index = -1;
                    },
                    title: 'Home'),
              ),
              GoRoute(
                name: recipesRoute.name,
                path: '${recipesRoute.path}/:days/:calories/:budget',
                builder: (context, state) {
                  int days = int.parse(state.pathParameters['days']!);
                  int calories = int.parse(state.pathParameters['calories']!);
                  int budget = int.parse(state.pathParameters['budget']!);
                  return RecipesPage(
                      title: 'Recipes',
                      days: days,
                      calories: calories,
                      budget: budget);
                },
              ),
              GoRoute(
                name: plansRoute.name,
                path: plansRoute.path,
                builder: (context, state) => const PlansPage(title: 'Plans'),
              ),
            ])
      ],
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
        popUntilPath(homeRoute.path);
        break;
      case 1:
        popUntilPath(plansRoute.path);
        break;
      default:
        router.go(homeRoute.path);
        break;
    }
  }
}
