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

  final Settings originalUserData = Settings();
  final Settings userData = Settings();

  loadSettings() async {
    _preferences = await SharedPreferences.getInstance();

    originalUserData.days = _preferences.getInt(_daysKey) ?? 1;
    originalUserData.calories = _preferences.getInt(_caloriesKey) ?? 1775;
    originalUserData.budget = _preferences.getInt(_budgetKey) ?? 100;

    originalUserData.weight = _preferences.getInt(_weightKey) ?? 77;
    originalUserData.height = _preferences.getInt(_heightKey) ?? 180;
    originalUserData.age = _preferences.getInt(_ageKey) ?? 25;
    originalUserData.gender = Gender.values.byName(_preferences.getString(_genderKey) ?? "male");
    originalUserData.activity = Activity.values
        .byName(_preferences.getString(_activityLevelKey) ?? "light");

    originalUserData.isFirstLaunch = _preferences.getBool(_isFirstLaunchKey) ?? true;
    copyOriginalData();
  }

  copyOriginalData(){
    userData.copyWith(originalUserData);
  }

  // Mifflin-St Jeor Equation
  int calculate() {
    int bodyModifier = userData.gender == Gender.male? 5 : -161;
    double calories = userData.activity.multiplier*(10 * userData.weight +
        6.25 * userData.height - 5 * userData.age + bodyModifier);
    return calories.toInt();
  }

  void saveSettings() async {
    originalUserData.copyWith(userData);
    _preferences.setInt(_daysKey, originalUserData.days);
    _preferences.setInt(_caloriesKey, originalUserData.calories);
    _preferences.setInt(_budgetKey, originalUserData.budget);

    _preferences.setInt(_weightKey, originalUserData.weight);
    _preferences.setInt(_heightKey, originalUserData.height);
    _preferences.setInt(_ageKey, originalUserData.age);
    _preferences.setString(_genderKey, originalUserData.gender.name.toLowerCase());
    _preferences.setString(_activityLevelKey, originalUserData.activity.name.toLowerCase());

    _preferences.setBool(_isFirstLaunchKey, originalUserData.isFirstLaunch);
  }
}

// SettingsRepository prover used by rest of the app.
final settingsRepositoryProvider =
    FutureProvider<SettingsRepository>((ref) async {
  final settingsRepository = SettingsRepository();
  await settingsRepository.loadSettings();
  return settingsRepository;
});
