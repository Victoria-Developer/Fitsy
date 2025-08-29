import 'package:fitsy/domain/enums/app_state.dart';
import 'package:fitsy/main.dart';
import 'package:fitsy/presentation/navigation/route.dart';
import 'package:fitsy/presentation/screens/error_screen.dart';
import 'package:fitsy/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/settings/settings_page.dart';
import '../screens/generator/generator_page.dart';
import '../widgets/dynamic_bottom_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final loadingRoute = NavRoute(path: "/loading", name: "loading");
final errorRoute = NavRoute(path: "/error", name: "error");
final onboardingRoute = NavRoute(path: "/onboarding", name: "onboarding");
final generatorRoute = NavRoute(
    path: "/generator", name: "generator", icon: const Icon(Icons.home));
final settingsRoute = NavRoute(
    path: "/settings", name: "settings", icon: const Icon(Icons.settings));

final bottomNavRoutes = [generatorRoute, settingsRoute];

final routerProvider = Provider<GoRouter>((ref) {
  final currentRoute = ref.watch(navigationProvider);
  final notifier = ref.read(navigationProvider.notifier);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: currentRoute.path,
    redirect: (context, state) {
      return currentRoute.path;
    },
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
            return _transition(SettingsPage(onOnboardingComplete: () {
              notifier.setRoute(generatorRoute);
            }));
          }),
      GoRoute(
        name: generatorRoute.name,
        path: generatorRoute.path,
        pageBuilder: (context, state) => _transition(GeneratorPage(
            bottomBar: DynamicBottomBar(routes: bottomNavRoutes))),
      ),
      GoRoute(
        name: settingsRoute.name,
        path: settingsRoute.path,
        pageBuilder: (context, state) => _transition(
            SettingsPage(bottomBar: DynamicBottomBar(routes: bottomNavRoutes))),
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

class NavigationNotifier extends StateNotifier<NavRoute> {
  NavigationNotifier(this.ref) : super(loadingRoute) {
    ref.listen<AsyncValue<AppState>>(appStateProvider, (_, next) {
      next.when(
        data: (data) {
          state =
          data == AppState.onboarding ? onboardingRoute : generatorRoute;
        },
        error: (_, __) => state = errorRoute,
        loading: () => state = loadingRoute,
      );
    });
  }

  final Ref ref;

  void setRoute(NavRoute route) => state = route;
}

final navigationProvider =
StateNotifierProvider<NavigationNotifier, NavRoute>((ref) {
  return NavigationNotifier(ref);
});