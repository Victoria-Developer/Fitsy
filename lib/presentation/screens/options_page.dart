import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/settings_repository.dart';
import '../../domain/enums/activity.dart';
import '../../domain/enums/gender.dart';
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
  late int days, budget, calories, weight, height, age;
  late Gender gender;
  late Activity activity;
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

      weight = settingsRepository.weight;
      height = settingsRepository.height;
      age = settingsRepository.age;
      gender = settingsRepository.gender;
      activity = settingsRepository.activity;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, // Full height
          alignment: Alignment.center, // Centers the content
          child: isLoading
              ? CircularProgressIndicator()
              : _buildMainContent(),
        ),
      ),
    );
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
              _buildDropDownList(days, daysList, (value) => days = value,
                  (value) => value.toString()),
              const Text('days')
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Gender: '),
              _buildDropDownList(gender, Gender.values,
                  (value) => gender = value, (value) => value.name),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Exercises intensity: "),
              _buildDropDownList(activity, Activity.values,
                  (value) => activity = value, (value) => value.name)
            ],
          ),
          _buildNumericTextField('Age', age, '25', (value) {
            age = value;
          }),
          _buildNumericTextField('Weight (kg)', weight, '77', (value) {
            weight = value;
          }),
          _buildNumericTextField('Height (cm)', height, '180', (value) {
            height = value;
          }),
          _buildNumericTextField('Budget per day (usd)', budget, '500',
              (value) {
            budget = value;
          }),
          const SizedBox(height: 20),
          Text("$calories kcal recommended per day"),
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

  DropdownButton<T> _buildDropDownList<T>(T listValue, List<T> list,
      void Function(T) onChanged, String Function(T) toString) {
    return DropdownButton<T>(
      value: listValue,
      dropdownColor: Color(0xFFB8C4A8),
      items: list.map<DropdownMenuItem<T>>((T value) {
        // Explicit generic type
        return DropdownMenuItem<T>(
          value: value,
          child: Text(
            toString(value),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      }).toList(),
      onChanged: (T? value) {
        if (value != null) {
          setState(() => onChanged(value)); // Updates the actual state variable
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        settingsRepository
          ..setDays(days)
          ..setBudget(budget)
          ..setWeight(weight)
          ..setHeight(height)
          ..setAge(age)
          ..setGender(gender)
          ..setActivity(activity)
          ..calculate();

        setState(() {
          calories = settingsRepository.calories;
        });

        if (settingsRepository.isFirstLaunch) {
          settingsRepository.setFirstLaunch(false);
          // Send data to recipes screen
          widget.onNavigateToRecipesPage();
        }
      },
      child: const Text('Save'),
    );
  }
}
