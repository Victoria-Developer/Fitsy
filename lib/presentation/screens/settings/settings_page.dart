import 'package:fitsy/domain/models/settings.dart';
import 'package:fitsy/presentation/navigation/app_navigator.dart';
import 'package:fitsy/presentation/screens/settings/settings_notifier.dart';
import 'package:fitsy/presentation/widgets/dynamic_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/enums/activity.dart';
import '../../../domain/enums/gender.dart';
import '../../widgets/outlined_text_field.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key, this.onOnboardingComplete, this.bottomBar});

  final void Function()? onOnboardingComplete;

  final DynamicBottomBar? bottomBar;

  @override
  ConsumerState<SettingsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends ConsumerState<SettingsPage> {
  final daysList = List.generate(7, (index) => index + 1);
  late TextEditingController ageController;
  late TextEditingController weightController;
  late TextEditingController heightController;
  late TextEditingController budgetController;
  late Settings userData;
  late SettingsNotifier notifier;

  @override
  void initState() {
    super.initState();
    ageController = TextEditingController();
    weightController = TextEditingController();
    heightController = TextEditingController();
    budgetController = TextEditingController();
  }

  @override
  void dispose() {
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => const Text("Error happened while loading settings."),
      data: (userData) {
        this.userData = userData;
        notifier = ref.read(settingsProvider.notifier);
        return _buildMainContent();
      },
    );
  }

  Widget _buildMainContent() {
    // Reset main content each time user navigates to another screen
    // to prevent showing unsaved settings
    ref.listen(navigationProvider, (prev, next) {
      notifier.reset();
    });

    ageController.text = userData.age.toString();
    weightController.text = userData.weight.toString();
    heightController.text = userData.height.toString();
    budgetController.text = userData.budget.toString();

    final widgets = <Widget>[
      _wrap([
        const Text('Use AI for menu plans: '),
        Switch(
          value: userData.useAI,
          activeColor: Colors.cyan,
          onChanged: (bool value) {
            setState(() => notifier.setUseAI(value));
          },
        ),
      ]),
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
      _wrap([
        const Text("Gender: "),
        _buildDropDownList(
          userData.gender,
          Gender.values,
          (value) => notifier.setGender(value),
          (value) => value.name,
        ),
      ]),
      _wrap([
        const Text("Exercises intensity: "),
        _buildDropDownList(
          userData.activity,
          Activity.values,
          (value) => notifier.setActivity(value),
          (value) => value.name,
        ),
      ]),
      _buildNumericTextField('Age:', notifier.setAge, ageController),
      _buildNumericTextField(
          'Weight (kg):', notifier.setWeight, weightController),
      _buildNumericTextField(
          'Height (cm):', notifier.setHeight, heightController),
      _buildNumericTextField(
          'Budget per day (usd):', notifier.setBudget, budgetController),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 60, bottom: 10),
                itemCount: widgets.length,
                itemBuilder: (context, index) => Center(child: widgets[index]),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: _buildSubmitButton(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.bottomBar,
    );
  }

  Widget _wrap(List<Widget> children) => Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.horizontal,
      spacing: 15, // <-- Spacing between children
      children: children);

  Widget _buildNumericTextField(String label, ValueChanged<int> onChanged,
      TextEditingController? controller) {
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
              controller: controller,
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
          style: Theme.of(context).textTheme.bodyMedium,
          value: listValue,
          items: list.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(toString(value),
                  style: Theme.of(context).textTheme.bodyMedium),
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

  Widget _buildSubmitButton() {
    final isFirstLaunch = userData.isFirstLaunch;
    return Wrap(
        spacing: 7,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.vertical,
        children: [
          if (!notifier.isDataSaved)
            Text("You've changed settings. Please, save.",
                style: TextStyle(
                  color: Colors.red,
                )),
          ElevatedButton(
            onPressed: () {
              notifier.saveSettings();
              if (isFirstLaunch) {
                print("call in settings");
                widget.onOnboardingComplete?.call();
              }
            },
            child: Text(isFirstLaunch ? "Next" : "Save",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          )
        ]);
  }
}
