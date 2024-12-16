import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/settings_repository.dart';
import '../widgets/outlined_text_field.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key, required this.onNavigateToRecipesPage});

  final void Function(int, int, int) onNavigateToRecipesPage;

  @override
  State<OptionsPage> createState() => _OptionsPagePageState();
}

class _OptionsPagePageState extends State<OptionsPage> {
  final daysList = [1, 2, 3, 4, 5, 6, 7];
  late SettingsRepository settingsRepository;
  late int days, calories, budget;
  late bool isFirstLaunch;

  @override
  initState() {
    settingsRepository = context.read<SettingsRepository>();
    days = settingsRepository.days;
    calories = settingsRepository.calories;
    budget = settingsRepository.budget;
    isFirstLaunch = settingsRepository.isFirstLaunch;
    super.initState();
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
            _buildDropDownDaysList(),
            const Text('days')
          ],
        ),
        const SizedBox(height: 20),
        const Text('Calories per day:'),
        OutlinedTextField(
            initialValue: calories.toString(),
            hintText: '1400',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEdit: (value) {
              _setCalories(int.parse(value));
            }),
        const SizedBox(height: 20),
        const Text('Budget per day in usd:'),
        OutlinedTextField(
            initialValue: budget.toString(),
            hintText: '500',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEdit: (value) {
              _setBudget(int.parse(value));
            }),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            settingsRepository.setDays(days);
            settingsRepository.setCalories(calories);
            settingsRepository.setBudget(budget);
            if (isFirstLaunch == true) {
              settingsRepository.setFirstLaunch(false);
            }
            // Send data to recipes screen
            widget.onNavigateToRecipesPage(days, calories, budget);
          },
          child: const Text('Ok'),
        ),
      ],
    )));
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
