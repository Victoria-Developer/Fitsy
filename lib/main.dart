import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:fitsy/presentation/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/database/app_box.dart';

late AppNavigator _navigation;
late AppBox _appBox;
late SettingsRepository _settingsRepository;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  _appBox = await AppBox.create();

  _settingsRepository = SettingsRepository();
  await _settingsRepository.loadSettings();

  _navigation = AppNavigator(_settingsRepository.isFirstLaunch);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(
        providers: [
          Provider<AppBox>(create: (_) => _appBox),
          Provider<SettingsRepository>(create: (_) => _settingsRepository),
        ],
      child: MaterialApp.router(
        title: 'Fitsy',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime.shade100),
          //cardTheme: CardTheme(color:Colors.lime.shade100),
          textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: screenWidth * 0.05), // Regular text
          ),
          useMaterial3: true,
        ),
        routerConfig: _navigation.router,
      ),
    );
  }
}
