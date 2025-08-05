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
  late Settings userData;

  bool isLoading = true;

  @override
  initState() {
    super.initState();
    _initSettings();
  }

  _initSettings() async {
    settingsRepository = await ref.read(settingsRepositoryProvider.future);
    setState(() {
      settingsRepository.copyOriginalData();
      userData = settingsRepository.userData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _padded(
                _wrap([
                  const Text('Meal plan for: '),
                  _buildDropDownList(
                    userData.days,
                    daysList,
                    (value) => userData.days = value,
                    (value) => value.toString(),
                  ),
                  const Text('days'),
                ]),
              ),
              _padded(
                _wrap([
                  const Text("Gender: "),
                  _buildDropDownList(
                    userData.gender,
                    Gender.values,
                    (value) => userData.gender = value,
                    (value) => value.name,
                  ),
                ]),
              ),
              _padded(
                _wrap([
                  const Text("Exercises intensity: "),
                  _buildDropDownList(
                    userData.activity,
                    Activity.values,
                    (value) => userData.activity = value,
                    (value) => value.name,
                  ),
                ]),
              ),
              _padded(
                _buildNumericTextField('Age:', userData.age, '25', (value) {
                  userData.age = value;
                }),
              ),
              _padded(
                _buildNumericTextField('Weight (kg):', userData.weight, '77',
                    (value) {
                  userData.weight = value;
                }),
              ),
              _padded(
                _buildNumericTextField('Height (cm):', userData.height, '180',
                    (value) {
                  userData.height = value;
                }),
              ),
              _padded(
                _buildNumericTextField(
                    'Budget per day (usd):', userData.budget, '500', (value) {
                  userData.budget = value;
                }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "${userData.calories} kcal recommended per day",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildSubmitButton(),
        ],
      ),
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
      children: children);

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
                userData.calories = settingsRepository.calculate();
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
                userData.calories = settingsRepository.calculate();
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
        if (userData.isFirstLaunch) {
          userData.isFirstLaunch = false;
          // Send data to recipes screen
          widget.onNavigateToRecipesPage();
        }
        settingsRepository.saveSettings();
      },
      child: const Text('Save'),
    );
  }
}
