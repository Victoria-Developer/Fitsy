import 'package:flutter/material.dart';

class VisibilityComponent extends StatefulWidget {
  final String instructions;

  const VisibilityComponent({required this.instructions, super.key});

  @override
  VisibilityComponentState createState() => VisibilityComponentState();
}

class VisibilityComponentState extends State<VisibilityComponent> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    String text() => isVisible ? "Hide" : "Show";

    return Wrap(
        alignment: WrapAlignment.center,
        runSpacing: 20,
        children: [
      ElevatedButton(
        onPressed: () => setState(() {
          isVisible = !isVisible;
        }),
        child: Text("${text()} instructions"),
      ),
      //SizedBox(height: 20),
      if (isVisible)
        Text(widget.instructions, textAlign: TextAlign.center, softWrap: true),
    ]);
  }
}