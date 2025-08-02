import 'package:flutter/material.dart';

class RedirectionPage extends StatelessWidget {
  const RedirectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            "Loading data...",
              style: TextStyle(fontSize: 40)
          ),
          const CircularProgressIndicator()
        ],
      ),
    ));
  }
}
