import 'package:fitsy/presentation/navigation/app_navigator.dart';
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
      theme: getAppThemeData(),
      routerConfig: router,
    );
  }

  ThemeData getAppThemeData(){
    final fontSize = MediaQuery.of(context).size.width * 0.05;
    return ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFFB8860B),
        // Button selected text color
        onPrimary: Colors.black,
        secondary: Colors.black,
        onSecondary: Colors.black,
        surface: Color(0xFFA4B494),
        // Background
        onSurface: Colors.black,
        // Text color
        error: Color(0xFFFF5252),
        // Error color
        onError: Colors.white, // Text on error color
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: fontSize),
            backgroundColor: Color(0xFF8A9C81), // Button background color
            foregroundColor: Colors.black, // Text color
          )),
      textTheme: TextTheme(
          bodyMedium:
          TextStyle(fontSize: fontSize)
      ),
      useMaterial3: true,
    );
  }
}
