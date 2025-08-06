import 'package:fitsy/presentation/screens/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
      super.key,
      required this.onNavigateToOnboarding,
      required this.onNavigateToRecipes
  });

  final Function onNavigateToOnboarding;
  final Function onNavigateToRecipes;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() async {
    final settings = await ref.read(settingsProvider.future);
    settings.isFirstLaunch
        ? widget.onNavigateToOnboarding()
        : widget.onNavigateToRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Loading data...", style: TextStyle(fontSize: 40)),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
