import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:fitsy/presentation/navigation/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/redirection_page.dart';
import '../screens/options_page.dart';
import '../screens/recipes_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final redirectionRoute = NavRoute(path: "/redirection", name: "redirection");
final onboardingRoute = NavRoute(path: "/onboarding", name: "onboarding");
final recipesRoute = NavRoute(path: "/recipes", name: "recipes");
final optionsRoute = NavRoute(path: "/options", name: "options");

int currentNavIndex = 0;

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
            if (settingsValue.userData.isFirstLaunch == true) {
              currentNavIndex = 1;
              return optionsRoute.path;
            } else {
              currentNavIndex = 0;
              return recipesRoute.path;
            }
          }),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: SafeArea(child: navigationShell),
            bottomNavigationBar: _buildNavBar(context),
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
                pageBuilder: (context, state) => _transition(OptionsPage(
                  onNavigateToRecipesPage: () =>
                      context.goNamed(recipesRoute.name),
                )),
              )
            ],
          ),
        ],
      ),
    ],
  );
});

CustomTransitionPage _transition(Widget child){
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity:
        CurveTween(curve: Curves.easeInOutCirc).animate(animation),
        child: child,
      );
    },
  );
}

Widget _buildNavBar(BuildContext context) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 5.0,
    clipBehavior: Clip.antiAlias,
    child: SizedBox(
      height: kBottomNavigationBarHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildIconButton(const Icon(Icons.home), 0,
              () => context.replaceNamed(recipesRoute.name)),
          _buildIconButton(const Icon(Icons.settings), 1,
              () => context.replaceNamed(optionsRoute.name)),
        ],
      ),
    ),
  );
}

IconButton _buildIconButton(Icon icon, int index, onNavigation) {
  return IconButton(
      icon: icon,
      iconSize: 30.0,
      isSelected: currentNavIndex == index,
      onPressed: () {
        currentNavIndex = index;
        onNavigation();
      });
}
