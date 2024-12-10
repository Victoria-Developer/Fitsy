import 'package:flutter/material.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key, required this.title});

  final String title;

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: const Center(
          child: Text("Plans placeholder")
        ),
    );
  }

}