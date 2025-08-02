import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:fitsy/presentation/navigation/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/redirection_page.dart';
import '../screens/options_page.dart';
import '../screens/recipes_page.dart';
import '../widgets/dynamic_bottom_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final redirectionRoute = NavRoute(path: "/redirection", name: "redirection");
final onboardingRoute = NavRoute(path: "/onboarding", name: "onboarding");
final recipesRoute = NavRoute(path: "/recipes", name: "recipes");
final optionsRoute = NavRoute(path: "/options", name: "options");

final routerProvider = Provider<GoRouter>((ref) {
  final settings = ref.watch(settingsRepositoryProvider);
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: redirectionRoute.path,
    routes: [
      GoRoute(
          name: redirectionRoute.name,
          path: redirectionRoute.path,
          builder: (context, state) {
            return RedirectionPage();
          },
          redirect: (context, state) {
            if (settings is AsyncLoading || settings is AsyncError) {
              return null;
            }
            final settingsValue = settings.value!;
            if (settingsValue.settings.isFirstLaunch == true) {
              return optionsRoute.path;
            } else {
              return recipesRoute.path;
            }
          }),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: SafeArea(child: navigationShell),
            bottomNavigationBar:
                DynamicBottomBar(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: recipesRoute.name,
                path: recipesRoute.path,
                builder: (context, state) => RecipesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                name: optionsRoute.name,
                path: optionsRoute.path,
                builder: (context, state) => OptionsPage(
                  onNavigateToRecipesPage: () =>
                      context.goNamed(recipesRoute.name),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
