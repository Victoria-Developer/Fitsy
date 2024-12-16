import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:fitsy/presentation/navigation/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'data/database/app_box.dart';

Future<void> main() async {
  // This is required so ObjectBox can get the application directory
  // to store the database in.
  WidgetsFlutterBinding.ensureInitialized();
  final appBox = await AppBox.create();

  final settingsRepository = SettingsRepository();
  await settingsRepository.loadSettings();

  final navigation = AppNavigator(settingsRepository.isFirstLaunch);

  runApp(App(
    settingsRepository: settingsRepository,
    appBox: appBox,
    router: navigation.router,
  ));
}

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.settingsRepository,
      required this.appBox,
      required this.router});

  final SettingsRepository settingsRepository;
  final AppBox appBox;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MultiProvider(
      providers: [
        Provider<AppBox>(create: (_) => appBox),
        Provider<SettingsRepository>(create: (_) => settingsRepository),
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
        routerConfig: router,
      ),
    );
  }
}
