import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:fitsy/presentation/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database/app_box.dart';

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  final appBox = await AppBox.create();

  final settingsRepository = SettingsRepository();
  await settingsRepository.loadSettings();

  runApp(MultiProvider(
    providers: [
      Provider<AppBox>(create: (_) => appBox),
      Provider<SettingsRepository>(create: (_) => settingsRepository),
    ],
    child: App(),
  ));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {

  late final AppNavigator navigation;

  @override
  void initState() {
    navigation = AppNavigator(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp.router(
      title: 'Fitsy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime.shade100),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: screenWidth * 0.05), // Regular text
        ),
        useMaterial3: true,
      ),
      routerConfig: navigation.router,
    );
  }
}
