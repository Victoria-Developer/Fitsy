
import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:fitsy/presentation/navigation/route.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


import '../screens/options_page.dart';
import '../screens/recipes_page.dart';
import '../widgets/dynamic_bottom_bar.dart';

class AppNavigator {

  late GoRouter router;
  final _rootNavigatorKey = GlobalKey<NavigatorState>();

  final onboardingRoute =  NavRoute(id: -1, path: "/onboarding", name: "onboarding");
  final recipesRoute = NavRoute(id: 0, path: "/recipes", name: "recipes");
  final optionsRoute = NavRoute(id: 1, path: "/options", name: "options");

  AppNavigator(bool isFirstLaunch) {

    final routes = <NavRoute>[recipesRoute, optionsRoute];

    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: isFirstLaunch ? onboardingRoute.path : recipesRoute.path,
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
                });
            return _buildScreenWithStaticBottomBar(
                    state, routes, child, optionsRoute.id);
          },
        ),
        GoRoute(
          name: recipesRoute.name,
          path: recipesRoute.path,
          builder: (context, state) {
            final settingsRepository = context.read<SettingsRepository>();
            final extra = state.extra as Map<String, String>?;
            final days =
                int.tryParse(extra?['days'] ?? '') ?? settingsRepository.days;
            final calories = int.tryParse(extra?['calories'] ?? '') ??
                settingsRepository.calories;
            final budget = int.tryParse(extra?['budget'] ?? '') ??
                settingsRepository.budget;

            final child = RecipesPage(
              days: days,
              calories: calories,
              budget: budget,
            );
            return _buildScreenWithStaticBottomBar(
                state, routes, child, recipesRoute.id);
          },
        ),
        GoRoute(
          name: onboardingRoute.name,
          path: onboardingRoute.path,
          builder: (context, state) {
            final child = OptionsPage(
                onNavigateToPlanGeneratorPage: (days, calories, budget) {
                  // Navigate without ability to return to the Onboarding page.
                  router.goNamed(recipesRoute.name, extra: {
                    "days": "$days",
                    "calories": "$calories",
                    "budget": "$budget"
                  });
                });
            return child;
          },
        )
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
