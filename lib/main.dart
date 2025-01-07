import 'package:fitsy/presentation/navigation/app_navigator.dart';
import 'package:fitsy/presentation/themes/fitsy_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

main() {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(
    child: App(),
  ));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.read(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Fitsy',
      theme: FitsyTheme().getMaterialTheme(context),
      routerConfig: router,
    );
  }
}


