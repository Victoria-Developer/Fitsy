import 'package:fitsy/models/settings.dart';
import 'package:fitsy/widgets/outlined_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../repositories/settings_repository.dart';

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
  late Future<Settings> settings;
  late int days;
  late int calories;
  late int budget;

  @override
  initState() {
    loadPrefs();
    super.initState();
  }

  loadPrefs() async {
    var settingsRepository = SettingsRepository.instance;
    settings = settingsRepository.loadPrefs();
    settings.then((onValue) {
      days = onValue.days;
      calories = onValue.calories;
      budget = onValue.budget;
    });
  }

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
            child: FutureBuilder<Settings>(
                future: settings,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    return _buildSettingsPanel();
                  } else {
                    return const Text("No data");
                  }
                })));
  }

  Widget _buildSettingsPanel() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          spacing: 20, // <-- Spacing between children
          children: <Widget>[
            const Text('Meal plan for'),
            _buildDropDownDaysList(),
            const Text('days')
          ],
        ),
        const SizedBox(height: 20),
        OutlinedTextField(
            initialValue: calories.toString(),
            labelText: 'Calories',
            hintText: '1400',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEdit: (value) {
              _setCalories(int.parse(value));
            }),
        const SizedBox(height: 20),
        OutlinedTextField(
            initialValue: budget.toString(),
            labelText: 'Budget for whole meal period in usd',
            hintText: '500',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEdit: (value) {
              _setBudget(int.parse(value));
            }),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Send data to recipes screen
            widget.onNavigateToRecipes(days, calories, budget);
          },
          child: const Text('Plan meals'),
        ),
      ],
    );
  }

  Widget _buildDropDownDaysList() {
    return DropdownButton<int>(
      value: days,
      items: daysList.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(
            value.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }).toList(),
      onChanged: (int? value) {
        _setDays(value!);
      },
    );
  }
}
