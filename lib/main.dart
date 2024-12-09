import 'package:fitsy/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Fitsy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardTheme(
            color: Colors.white60,
            shadowColor: Colors.lime.shade50
        ),
        textTheme: TextTheme(
            bodyMedium: TextStyle(fontSize: screenWidth * 0.05) // Regular text
        ),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Home'),
    );
  }
}
