import 'package:fitsy/domain/enums/activity.dart';
import 'package:fitsy/domain/enums/gender.dart';
import 'package:fitsy/domain/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Riverpod(keepAlive: true)
class SettingsRepository {
  late final SharedPreferences _preferences;

  final String _daysKey = "days";
  final String _caloriesKey = "calories";
  final String _budgetKey = "budget"; // usd
  final String _weightKey = "weight"; // kg
  final String _heightKey = "height"; // cm
  final String _ageKey = "age";
  final String _genderKey = "gender";
  final String _activityLevelKey = "activity";
  final String _isFirstLaunchKey = "is_first_launch";

  final Settings settings = Settings();

  loadSettings() async {
    _preferences = await SharedPreferences.getInstance();

    settings.days = _preferences.getInt(_daysKey) ?? 1;
    settings.calories = _preferences.getInt(_caloriesKey) ?? 1775;
    settings.budget = _preferences.getInt(_budgetKey) ?? 100;

    settings.weight = _preferences.getInt(_weightKey) ?? 77;
    settings.height = _preferences.getInt(_heightKey) ?? 180;
    settings.age = _preferences.getInt(_ageKey) ?? 25;
    settings.gender = Gender.values.byName(_preferences.getString(_genderKey) ?? "male");
    settings.activity = Activity.values
        .byName(_preferences.getString(_activityLevelKey) ?? "light");

    settings.isFirstLaunch = _preferences.getBool(_isFirstLaunchKey) ?? true;
  }

  // Mifflin-St Jeor Equation
  int calculate() {
    int bodyModifier = settings.gender == Gender.male? 5 : -161;
    double calories = settings.activity.multiplier*(10 * settings.weight +
        6.25 * settings.height - 5 * settings.age + bodyModifier);
    return calories.toInt();
  }

  void saveSettings() async {
    _preferences.setInt(_daysKey, settings.days);
    _preferences.setInt(_caloriesKey, settings.calories);
    _preferences.setInt(_budgetKey, settings.budget);

    _preferences.setInt(_weightKey, settings.weight);
    _preferences.setInt(_heightKey, settings.height);
    _preferences.setInt(_ageKey, settings.age);
    _preferences.setString(_genderKey, settings.gender.name.toLowerCase());
    _preferences.setString(_activityLevelKey, settings.activity.name.toLowerCase());

    _preferences.setBool(_isFirstLaunchKey, settings.isFirstLaunch);
  }
}

// SettingsRepository prover used by rest of the app.
final settingsRepositoryProvider =
    FutureProvider<SettingsRepository>((ref) async {
  final settingsRepository = SettingsRepository();
  await settingsRepository.loadSettings();
  return settingsRepository;
});
