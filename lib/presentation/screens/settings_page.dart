import 'package:fitsy/domain/models/settings.dart';
import 'package:fitsy/presentation/screens/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/enums/activity.dart';
import '../../domain/enums/gender.dart';
import '../widgets/outlined_text_field.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, this.onNavigateToRecipesPage});

  final void Function()? onNavigateToRecipesPage;

  @override
  ConsumerState<SettingsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends ConsumerState<SettingsPage> {
  final daysList = List.generate(7, (index) => index + 1);
  final submitButtonStyle = GoogleFonts.ebGaramond(fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset settings to original each time user opens the page
      ref.read(settingsProvider.notifier).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return settingsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => const Text("Error happened while loading settings."),
      data: (userData) => _buildMainContent(userData, notifier),
    );
  }

  Widget _buildMainContent(Settings userData, SettingsNotifier notifier) {
    return Scaffold(
        body: Card(
            child: Center(
          child: SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _padded(_wrap([
                const Text('Use AI for menu plans: '),
                Switch(
                  value: userData.useAI,
                  activeColor: Colors.cyan,
                  onChanged: (bool value) {
                    setState(() {
                      notifier.setUseAI(value);
                    });
                  },
                )
              ])),
              _padded(
                _wrap([
                  const Text('Meal plan for: '),
                  _buildDropDownList(
                    userData.days,
                    daysList,
                    (value) => notifier.setDays(value),
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
                    (value) => notifier.setGender(value),
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
                    (value) => notifier.setActivity(value),
                    (value) => value.name,
                  ),
                ]),
              ),
              _padded(
                _buildNumericTextField(
                    'Age:', userData.age, (value) => notifier.setAge(value)),
              ),
              _padded(
                _buildNumericTextField('Weight (kg):', userData.weight,
                    (value) => notifier.setWeight(value)),
              ),
              _padded(
                _buildNumericTextField('Height (cm):', userData.height,
                    (value) => notifier.setHeight(value)),
              ),
              _padded(
                _buildNumericTextField('Budget per day (usd):', userData.budget,
                    (value) => notifier.setBudget(value)),
              )
            ],
          )),
        )),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              // adjust as needed
              child: _buildSubmitButton(userData.isFirstLaunch, notifier),
            ),
          ],
        ));
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

  Widget _buildNumericTextField(
      String label, int initialValue, ValueChanged<int> onChanged) {
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
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onEdit: (value) => onChanged(int.parse(value))),
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
              onChanged(value);
            }
          },
          dropdownColor: Colors.white,
          underline: const SizedBox.shrink(),
          iconEnabledColor: Colors.black,
        ));
  }

  Widget _buildSubmitButton(bool isFirstLaunch, SettingsNotifier notifier) {
    return ElevatedButton(
      onPressed: () {
        if (isFirstLaunch) {
          notifier.setFirstLaunch(false);
          widget.onNavigateToRecipesPage?.call();
        }
        notifier.saveSettings();
      },
      child: Text(isFirstLaunch ? "Next" : "Save", style: submitButtonStyle),
    );
  }
}
