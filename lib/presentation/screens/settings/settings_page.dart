import 'package:fitsy/domain/models/settings.dart';
import 'package:fitsy/presentation/screens/settings/settings_notifier.dart';
import 'package:fitsy/presentation/widgets/decorated_drop_down_list.dart';
import 'package:fitsy/presentation/widgets/warning_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/enums/activity.dart';
import '../../../domain/enums/gender.dart';
import '../../widgets/dynamic_bottom_bar.dart';
import '../../navigation/routes.dart';
import '../../widgets/numeric_text_field.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final daysList = List.generate(7, (index) => index + 1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Reset settings to original each time user opens the page
      final notifier = ref.read(settingsProvider.notifier);
      if (!notifier.isDataSaved) notifier.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return settingsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => const Text("Error happened while loading settings."),
      data: (userData) {
        final content = _buildMainContent(userData, notifier);
        final saveButtonTextTheme =
            Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                );

        return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  WarningWidget(
                      isShown: !notifier.isDataSaved,
                      message: "Don’t forget to save!"),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 25, bottom: 10),
                      itemCount: content.length,
                      itemBuilder: (context, index) =>
                          Center(child: content[index]),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 17),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Wrap(
                          spacing: 7,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          direction: Axis.vertical,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  onSave(userData.isFirstLaunch, notifier),
                              child: Text("Save", style: saveButtonTextTheme),
                            )
                          ])),
                ],
              ),
            ),
            bottomNavigationBar:
                userData.isFirstLaunch ? null : const DynamicBottomBar());
      },
    );
  }

  onSave(bool isFirstLaunch, SettingsNotifier notifier) {
    notifier.saveSettings();
    if (isFirstLaunch) {
      context.go(generatorRoute.path);
    }
  }

  List<Widget> _buildMainContent(
          Settings userData, SettingsNotifier notifier) =>
      <Widget>[
        Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.horizontal,
            spacing: 15,
            children: [
              const Text('Use AI for menu plans: '),
              Switch(
                value: userData.useAI,
                activeColor: Colors.cyan,
                onChanged: (bool value) {
                  setState(() => notifier.setUseAI(value));
                },
              )
            ]),
        DecoratedDropDownList(
          label: "Days: ",
          value: userData.days,
          items: daysList,
          onChanged: (value) => notifier.setDays(value),
          itemToString: (value) => value.toString(),
        ),
        DecoratedDropDownList(
          label: "Gender: ",
          value: userData.gender,
          items: Gender.values,
          onChanged: (value) => notifier.setGender(value),
          itemToString: (value) => value.name,
        ),
        DecoratedDropDownList(
            label: "Exercises intensity: ",
            value: userData.activity,
            items: Activity.values,
            onChanged: (value) => notifier.setActivity(value),
            itemToString: (value) => value.name),
        NumericTextField(
            label: 'Age:',
            onChanged: notifier.setAge,
            initialValue: userData.age.toString()),
        NumericTextField(
            label: 'Weight (kg):',
            onChanged: notifier.setWeight,
            initialValue: userData.weight.toString()),
        NumericTextField(
            label: 'Height (cm):',
            onChanged: notifier.setHeight,
            initialValue: userData.height.toString()),
        NumericTextField(
            label: 'Budget per day (usd):',
            onChanged: notifier.setBudget,
            initialValue: userData.budget.toString()),
      ];
}
