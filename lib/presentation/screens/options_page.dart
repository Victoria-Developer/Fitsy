import 'package:fitsy/domain/models/settings.dart';
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
  late Settings settings;

  bool isLoading = true;

  @override
  initState() {
    _initSettings();
    super.initState();
  }

  _initSettings() async {
    settingsRepository = await ref.read(settingsRepositoryProvider.future);
    setState(() {
      settings = settingsRepository.settings;
      if (settings.isFirstLaunch) {
        settings.isFirstLaunch = false;
      }
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
          child: isLoading ? CircularProgressIndicator() : _buildMainContent(),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _padded(
          _wrap([
            const Text('Meal plan for: '),
            _buildDropDownList(settings.days, daysList,
                    (value) => settings.days = value, (value) => value.toString()),
            const Text('days')
          ]),
        ),
        _padded(
          _wrap([
            const Text("Gender: "),
            _buildDropDownList(settings.gender, Gender.values,
                    (value) => settings.gender = value, (value) => value.name),
          ]),
        ),
        _padded(
          _wrap([
            const Text("Exercises intensity: "),
            _buildDropDownList(settings.activity, Activity.values,
                    (value) => settings.activity = value, (value) => value.name),
          ]),
        ),
        _padded(_buildNumericTextField('Age:', settings.age, '25', (value) {
          settings.age = value;
        })),
        _padded(_buildNumericTextField('Weight (kg):', settings.weight, '77',
                (value) {
              settings.weight = value;
            })),
        _padded(_buildNumericTextField('Height (cm):', settings.height, '180',
                (value) {
              settings.height = value;
            })),
        _padded(_buildNumericTextField(
            'Budget per day (usd):', settings.budget, '500', (value) {
          settings.budget = value;
        })),
        const SizedBox(height: 40),
        Text("${settings.calories} kcal recommended per day",
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        _buildSubmitButton()
      ],
    );
  }

  Widget _padded(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: child,
      );

  Widget _wrap(List<Widget> children) => Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      spacing: 20, // <-- Spacing between children
      children: children
  );

  Widget _buildNumericTextField(String label, int initialValue, String hintText,
      ValueChanged<int> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Text(label),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: OutlinedTextField(
            initialValue: initialValue.toString(),
            hintText: hintText,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onEdit: (value) {
              setState(() {
                onChanged(int.parse(value));
                settings.calories = settingsRepository.calculate();
              });
            },
          ),
        ),
      ],
    );
  }

  Container _buildDropDownList<T>(
    T listValue,
    List<T> list,
    void Function(T) onChanged,
    String Function(T) toString,
  ) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: DropdownButton<T>(
          value: listValue,
          items: list.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(toString(value)),
            );
          }).toList(),
          onChanged: (T? value) {
            if (value != null) {
              setState(() {
                onChanged(value);
                settings.calories = settingsRepository.calculate();
              });
            }
          },
          dropdownColor: Colors.white,
          underline: const SizedBox.shrink(),
          iconEnabledColor: Colors.black,
        ));
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        settingsRepository.saveSettings();
        if (settings.isFirstLaunch) {
          // Send data to recipes screen
          widget.onNavigateToRecipesPage();
        }
      },
      child: const Text('Save'),
    );
  }
}
