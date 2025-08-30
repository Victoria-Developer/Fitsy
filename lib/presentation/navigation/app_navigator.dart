import 'package:fitsy/presentation/navigation/routes.dart';
import 'package:fitsy/presentation/screens/error_screen.dart';
import 'package:fitsy/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/settings/settings_page.dart';
import '../screens/generator/generator_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: loadingRoute.path,
    routes: [
      GoRoute(
          name: loadingRoute.name,
          path: loadingRoute.path,
          pageBuilder: (context, state) {
            return _transition(SplashScreen());
          }),
      GoRoute(
          name: errorRoute.name,
          path: errorRoute.path,
          pageBuilder: (context, state) {
            return _transition(ErrorScreen(
              errorMessage: "Error occurred.",
            ));
          }),
      GoRoute(
          name: onboardingRoute.name,
          path: onboardingRoute.path,
          pageBuilder: (context, state) {
            return _transition(SettingsPage());
          }),
      GoRoute(
        name: generatorRoute.name,
        path: generatorRoute.path,
        pageBuilder: (context, state) => _transition(GeneratorPage()),
      ),
      GoRoute(
        name: settingsRoute.name,
        path: settingsRoute.path,
        pageBuilder: (context, state) => _transition(SettingsPage()),
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