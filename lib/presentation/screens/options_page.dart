
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/repositories/settings_repository.dart';
import '../widgets/outlined_text_field.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage(
      {super.key, required this.title, required this.onNavigateToPlanGeneratorPage});

  final String title;
  final void Function(int, int, int) onNavigateToPlanGeneratorPage;

  @override
  State<OptionsPage> createState() => _OptionsPagePageState();
}

class _OptionsPagePageState extends State<OptionsPage> {
  final daysList = [1, 2, 3, 4, 5, 6, 7];
  final settingsRepository = SettingsRepository.instance;
  bool isDataLoaded = false;
  late int days, calories, budget;

  @override
  initState() {
    loadSettings();
    super.initState();
  }

  loadSettings() async {
    //await settingsRepository.loadSettings();
    days = settingsRepository.days;
    calories = settingsRepository.calories;
    budget = settingsRepository.budget;
    setState(() {
      isDataLoaded = true;
    });
  }

  _setDays(int days) {
    setState(() {
      this.days = days;
    });
    settingsRepository.saveDays(days);
  }

  _setCalories(int calories) {
    setState(() {
      this.calories = calories;
    });
    settingsRepository.saveCalories(calories);
  }

  _setBudget(int budget) {
    setState(() {
      this.budget = budget;
    });
    settingsRepository.saveBudget(budget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: isDataLoaded
                ? _buildSettingsPanel()
                : const CircularProgressIndicator()
            ));
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
        const Text('Overall calories:'),
        OutlinedTextField(
            initialValue: calories.toString(),
            hintText: '1400',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEdit: (value) {
              _setCalories(int.parse(value));
            }),
        const SizedBox(height: 20),
        const Text('Budget for whole meal period in usd:'),
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
            // Send data to recipes screen
            widget.onNavigateToPlanGeneratorPage(days, calories, budget);
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
