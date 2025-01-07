import 'package:fitsy/presentation/navigation/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/redirection_page.dart';
import '../screens/options_page.dart';
import '../screens/recipes_page.dart';
import '../widgets/dynamic_bottom_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final redirectionRoute =
    NavRoute(id: -1, path: "/redirection", name: "redirection");
final onboardingRoute =
    NavRoute(id: -1, path: "/onboarding", name: "onboarding");
final recipesRoute = NavRoute(id: 0, path: "/recipes", name: "recipes");
final optionsRoute = NavRoute(id: 1, path: "/options", name: "options");
final List<NavRoute> routes = <NavRoute>[recipesRoute, optionsRoute];

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: redirectionRoute.path,
    routes: [
      GoRoute(
        name: redirectionRoute.name,
        path: redirectionRoute.path,
        builder: (context, state) {
          return RedirectionPage(
              onNavigateToRecipesPage: () => context.goNamed(recipesRoute.name),
              onNavigateToOnboardingPage: () =>
                  context.goNamed(onboardingRoute.name));
        },
      ),
      GoRoute(
        name: recipesRoute.name,
        path: recipesRoute.path,
        builder: (context, state) {
          final child = RecipesPage();
          return _buildScreenWithStaticBottomBar(
              GoRouter.of(context), child, recipesRoute.id);
        },
      ),
      GoRoute(
        name: optionsRoute.name,
        path: optionsRoute.path,
        builder: (context, state) {
          final child = OptionsPage(
              onNavigateToRecipesPage: () =>
                  context.pushNamed(recipesRoute.name));
          return _buildScreenWithStaticBottomBar(
              GoRouter.of(context), child, optionsRoute.id);
        },
      ),
      GoRoute(
        name: onboardingRoute.name,
        path: onboardingRoute.path,
        builder: (context, state) {
          return OptionsPage(
              onNavigateToRecipesPage: () =>
                  context.goNamed(recipesRoute.name));
        },
      )
    ],
  );
});

Widget _buildScreenWithStaticBottomBar(router, child, index) {
  return Scaffold(
    body: SafeArea(child: child),
    bottomNavigationBar: DynamicBottomBar(
        onNavigateToTab: (selectedIndex) {
          _navigateTo(router, routes[selectedIndex].path);
        },
        currentTabId: index),
  );
}

void _navigateTo(router, String routePath) {
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
