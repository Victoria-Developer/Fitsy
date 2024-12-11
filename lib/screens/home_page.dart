import 'package:fitsy/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key, required this.title, required this.onNavigateToRecipes});

  final String title;
  final void Function(int, int, int) onNavigateToRecipes;

  @override
  State<HomePage> createState() => _HomePagePageState();
}

class _HomePagePageState extends State<HomePage> {
  final daysList = [1, 2, 3, 4, 5, 6, 7];
  int days = 1;
  int calories = 0;
  int budget = 0;

  _setDays(int days) {
    setState(() {
      this.days = days;
    });
  }

  _setCalories(int calories) {
    setState(() {
      this.calories = calories;
    });
  }

  _setBudget(int budget) {
    setState(() {
      this.budget = budget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            spacing: 20, // <-- Spacing between children
            children: <Widget>[
              const Text('Meal plan for'),
              _buildSettingsWidget(),
              const Text('days')
            ],
          ),
          const SizedBox(height: 20),
          OutlinedTextField(
              labelText: 'Calories',
              hintText: '1400',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onEdit: (value) {
                _setCalories(int.parse(value));
              }),
          const SizedBox(height: 20),
          OutlinedTextField(
              labelText: 'Budget for whole meal period in usd',
              hintText: '500',
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onEdit: (value) {
                _setBudget(int.parse(value));
              }
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Send data to recipes screen
              widget.onNavigateToRecipes(days, calories, budget);
            },
            child: const Text('Plan meals'),
          ),
        ],
      ),
    ));
  }

  _buildSettingsWidget() {
    return DropdownButton<int>(
        value: days,
        items: daysList.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (int? value) {
          _setDays(value!);
        },
        style: const TextStyle(color: Colors.black, fontSize: 25));
  }
}
