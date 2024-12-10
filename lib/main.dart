import 'package:fitsy/screens/home_page.dart';
import 'package:fitsy/screens/recipes_page.dart';
import 'package:fitsy/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            AppScaffold(child: child),
        routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const HomePage(title: 'Home'),
      ),
      GoRoute(
        name: 'recipes',
        path: '/recipes/:days',
        builder: (context, state) {
          int days = int.parse(state.pathParameters['days']!);
          return RecipesPage(title: 'Recipes', days:days);
        },
      ),
    ])
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp.router(
      title: 'Fitsy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme:
            CardTheme(color: Colors.white60, shadowColor: Colors.lime.shade50),
        textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: screenWidth * 0.05) // Regular text
            ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
