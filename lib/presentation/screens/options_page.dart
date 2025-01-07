import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/settings_repository.dart';
import '../widgets/outlined_text_field.dart';

class OptionsPage extends ConsumerStatefulWidget {
  const OptionsPage({super.key, required this.onNavigateToRecipesPage});

  final void Function() onNavigateToRecipesPage;

  @override
  ConsumerState<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends ConsumerState<OptionsPage> {
  final daysList = List.generate(7, (index) => index + 1);
  late SettingsRepository settingsRepository;
  late int days, calories, budget;
  bool isLoading = true;

  @override
  initState() {
    _initSettings();
    super.initState();
  }

  _initSettings() async {
    settingsRepository = await ref.read(settingsRepositoryProvider.future);
    setState(() {
      days = settingsRepository.days;
      calories = settingsRepository.calories;
      budget = settingsRepository.budget;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                isLoading ? CircularProgressIndicator() : _buildMainContent()));
  }

  Widget _buildMainContent() {
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
          _buildNumericTextField('Calories per day:', calories, '1400',
              (value) {
            calories = value;
          }),
          _buildNumericTextField('Budget per day in usd', budget, '500',
              (value) {
            budget = value;
          }),
          const SizedBox(height: 20),
          _buildSubmitButton()
        ]);
  }

  Widget _buildNumericTextField(String label, int initialValue, String hintText,
      ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(label),
        OutlinedTextField(
            initialValue: initialValue.toString(),
            hintText: hintText,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEdit: (value) => onChanged(int.parse(value))),
      ],
    );
  }

  DropdownButton<int> _buildDropDownDaysList() {
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
      onChanged: (int? value) => setState(() => days = value?? days),
    );
  }

  Widget _buildSubmitButton(){
    return ElevatedButton(
      onPressed: () {
        settingsRepository
          ..setDays(days)
          ..setCalories(calories)
          ..setBudget(budget);

        if (settingsRepository.isFirstLaunch) {
          settingsRepository.setFirstLaunch(false);
        }
        // Send data to recipes screen
        widget.onNavigateToRecipesPage();
      },
      child: const Text('Save'),
    );
  }

}
