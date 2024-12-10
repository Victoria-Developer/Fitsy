import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePagePageState();
}

class _HomePagePageState extends State<HomePage> {
  int days = 1;

  _setDays(int? days){
    setState(() {
      this.days = days!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSettingsWidget(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Send data to recipes screen
                  context.goNamed('recipes', pathParameters: {"days": "$days"});
                },
                child: const Text('Plan meals'),
              ),
            ],
          ),
        ));
  }

  _buildSettingsWidget() {
    var daysList = [1, 2, 3, 4, 5, 6, 7];
    return DropdownButton<int>(
      value: days,
      items: daysList.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (int? value) {
        _setDays(value);
      },
    );
  }
}
