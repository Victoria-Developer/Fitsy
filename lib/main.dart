import 'package:fitsy/presentation/navigation/app_navigator.dart';
import 'package:fitsy/presentation/themes/material_theme.dart';
import 'package:fitsy/presentation/themes/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/local/repositories/local_recipes_repository.dart';
import 'data/local/repositories/local_settings_repository.dart';
import 'domain/enums/app_state.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    final textTheme = createTextTheme(context, "EB Garamond", "EB Garamond");
    final theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fitsy',
      theme: theme.darkMediumContrast(),
      routerConfig: router,
    );
  }
}

class AppStateNotifier extends AsyncNotifier<AppState> {

  @override
  Future<AppState> build() async {
    final (settings, _) = await (
    ref.read(localSettingsRepositoryProvider.future),
    ref.read(localRecipesRepositoryProvider.future)
    ).wait;
    return settings.$2.isFirstLaunch ? AppState.onboarding : AppState.home;
  }
}

final appStateProvider =
AsyncNotifierProvider<AppStateNotifier, AppState>(AppStateNotifier.new);