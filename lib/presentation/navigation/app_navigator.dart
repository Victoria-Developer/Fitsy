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

  final onboardingRoute =
      NavRoute(id: -1, path: "/onboarding", name: "onboarding");
  static final recipesRoute =
      NavRoute(id: 0, path: "/recipes", name: "recipes");
  static final optionsRoute =
      NavRoute(id: 1, path: "/options", name: "options");
  final List<NavRoute> routes = <NavRoute>[recipesRoute, optionsRoute];

  AppNavigator(BuildContext context) {
    final settingsRepository = context.read<SettingsRepository>();

    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: settingsRepository.isFirstLaunch
          ? onboardingRoute.path
          : recipesRoute.path,
      routes: [
        GoRoute(
          name: optionsRoute.name,
          path: optionsRoute.path,
          builder: (context, state) {
            final child =
                OptionsPage(onNavigateToRecipesPage: (days, calories, budget) {
              _navigateToRecipesScreen(false, days, calories, budget);
            });
            return _buildScreenWithStaticBottomBar(
                state, child, optionsRoute.id);
          },
        ),
        GoRoute(
          name: recipesRoute.name,
          path: recipesRoute.path,
          builder: (context, state) {
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
                state, child, recipesRoute.id);
          },
        ),
        GoRoute(
          name: onboardingRoute.name,
          path: onboardingRoute.path,
          builder: (context, state) {
            return OptionsPage( // Can be a separate screen with welcoming
                onNavigateToRecipesPage: (days, calories, budget) {
              _navigateToRecipesScreen(true, days, calories, budget);
              settingsRepository.setFirstLaunch(false);
            });
          },
        )
      ],
    );
  }

  _navigateToRecipesScreen(bool isFirstLaunch, days, calories, budget) {
    final extra = {
      "days": "$days",
      "calories": "$calories",
      "budget": "$budget"
    };
    if (isFirstLaunch) {
      router.pushNamed(recipesRoute.name, extra: extra);
    } else {
      // Navigate without ability to go back.
      router.goNamed(recipesRoute.name, extra: extra);
    }
  }

  Widget _buildScreenWithStaticBottomBar(state, child, index) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: DynamicBottomBar(
          onNavigateToTab: (selectedIndex) {
            navigateTo(routes[index].path);
          },
          currentTabId: index),
    );
  }

  void navigateTo(String routePath) {
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
        router.pop();
      }
    }
  }
}
