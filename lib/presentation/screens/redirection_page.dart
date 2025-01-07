
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/settings_repository.dart';

class RedirectionPage extends ConsumerStatefulWidget {
  const RedirectionPage(
      {super.key,
      required this.onNavigateToRecipesPage,
      required this.onNavigateToOnboardingPage});

  final void Function() onNavigateToRecipesPage;
  final void Function() onNavigateToOnboardingPage;

  @override
  ConsumerState<RedirectionPage> createState() => _RedirectionPageState();
}

class _RedirectionPageState extends ConsumerState<RedirectionPage> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      _navigate();
    });
  }

  _navigate() async {
    final settings = await ref.read(settingsRepositoryProvider.future);
    bool isFirstLaunch = settings.isFirstLaunch;
    if (isFirstLaunch) {
      widget.onNavigateToOnboardingPage();
    } else {
      widget.onNavigateToRecipesPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/ic_launcher.png',
            height: 100,
            width: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome to Fitsy!",
              style: TextStyle(fontSize: 40)
          ),
        ],
      ),
    ));
  }
}
