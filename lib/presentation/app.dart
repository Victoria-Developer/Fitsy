import 'package:fitsy/domain/models/settings.dart';
import 'package:fitsy/presentation/themes/material_theme.dart';
import 'package:fitsy/presentation/themes/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/repositories/local_recipes_repository.dart';
import '../data/local/repositories/local_settings_repository.dart';
import 'navigation/app_navigator.dart';
import 'navigation/routes.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = createTextTheme(context, "EB Garamond", "EB Garamond");
    final theme = MaterialTheme(textTheme);

    final router = ref.watch(routerProvider);
    final appState = ref.watch(appStateProvider);
    appState.when(
      data: (data) {
        final nextRoute =
            data.isFirstLaunch ? onboardingRoute.path : generatorRoute.path;
        router.go(nextRoute);
      },
      loading: () => null,
      error: (_, __) => router.go(errorRoute.path),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fitsy',
      theme: theme.darkMediumContrast(),
      routerConfig: router,
    );
  }
}

class AppStateNotifier extends AsyncNotifier<Settings> {
  @override
  Future<Settings> build() async {
    final (settingsProvider, _) = await (
      ref.read(localSettingsRepositoryProvider.future),
      ref.read(localRecipesRepositoryProvider.future)
    ).wait;
    return settingsProvider.$2;
  }
}

final appStateProvider =
    AsyncNotifierProvider<AppStateNotifier, Settings>(AppStateNotifier.new);