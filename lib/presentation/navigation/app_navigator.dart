import 'package:fitsy/presentation/navigation/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';
import '../screens/options_page.dart';
import '../screens/recipes_page.dart';
import '../widgets/dynamic_bottom_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final redirectionRoute = NavRoute(path: "/redirection", name: "redirection");
final onboardingRoute = NavRoute(path: "/onboarding", name: "onboarding");
final recipesRoute =
    NavRoute(path: "/recipes", name: "recipes", icon: const Icon(Icons.home));
final optionsRoute = NavRoute(
    path: "/options", name: "options", icon: const Icon(Icons.settings));

NavRoute? _currentNavRoute;

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: redirectionRoute.path,
    routes: [
      GoRoute(
          name: redirectionRoute.name,
          path: redirectionRoute.path,
          builder: (context, state) {
            return SplashScreen(
                onNavigateToOnboarding: () =>
                    onNavigation(context, onboardingRoute),
                onNavigateToRecipes: () => onNavigation(context, recipesRoute));
          }),
      GoRoute(
          name: onboardingRoute.name,
          path: onboardingRoute.path,
          pageBuilder: (context, state) {
            return _transition(OptionsPage(
                onNavigateToRecipesPage: () =>
                    onNavigation(context, recipesRoute)));
          }),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: SafeArea(child: navigationShell),
            bottomNavigationBar: DynamicBottomBar(
                routes: [recipesRoute, optionsRoute],
                isSelected: (route) => isSelected(route),
                onNavigation: (context, route) => onNavigation(context, route)),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: recipesRoute.name,
                path: recipesRoute.path,
                pageBuilder: (context, state) => _transition(RecipesPage()),
              ),
              GoRoute(
                name: optionsRoute.name,
                path: optionsRoute.path,
                pageBuilder: (context, state) => _transition(OptionsPage()),
              )
            ],
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage _transition(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}

onNavigation(BuildContext context, NavRoute route) {
  _currentNavRoute = route;
  context.replaceNamed(route.name);
}

isSelected(NavRoute route) {
  return _currentNavRoute == route;
}
