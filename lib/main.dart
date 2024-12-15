import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:fitsy/presentation/navigation/app_navigator.dart';
import 'package:flutter/material.dart';

import 'data/database/app_box.dart';

late AppNavigator navigation;
late AppBox appBox;

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  appBox = await AppBox.create();
  await SettingsRepository.instance.loadSettings();
  navigation = AppNavigator.instance;

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp.router(
      title: 'Fitsy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime.shade100),
        //cardTheme: CardTheme(color:Colors.lime.shade100),
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: screenWidth * 0.05), // Regular text
        ),
        useMaterial3: true,
      ),
      routerConfig: navigation.router,
    );
  }
}
