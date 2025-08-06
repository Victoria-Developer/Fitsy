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

  Future<Settings> loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    Settings userData = Settings();

    changeVal(_preferences.getInt(_daysKey), (val) => userData.days = val);
    changeVal(
        _preferences.getInt(_caloriesKey), (val) => userData.calories = val);
    changeVal(_preferences.getInt(_budgetKey), (val) => userData.budget = val);
    changeVal(_preferences.getInt(_weightKey), (val) => userData.weight = val);
    changeVal(_preferences.getInt(_heightKey), (val) => userData.height = val);
    changeVal(_preferences.getInt(_ageKey), (val) => userData.age = val);
    changeVal<String>(
      _preferences.getString(_genderKey),
      (val) => userData.gender = Gender.values.byName(val),
    );
    changeVal<String>(
      _preferences.getString(_activityLevelKey),
      (val) => userData.activity = Activity.values.byName(val),
    );
    changeVal(_preferences.getBool(_isFirstLaunchKey),
        (val) => userData.isFirstLaunch = val);

    return userData;
  }

  void changeVal<T>(T? value, void Function(T val) onChange) {
    if (value != null) onChange(value);
  }

  // Mifflin-St Jeor Equation
  int calculate(Settings userData) {
    int bodyModifier = userData.gender == Gender.male ? 5 : -161;
    double calories = userData.activity.multiplier *
        (10 * userData.weight +
            6.25 * userData.height -
            5 * userData.age +
            bodyModifier);
    return calories.toInt();
  }

  void saveSettings(Settings userData) async {
    _preferences.setInt(_daysKey, userData.days);
    _preferences.setInt(_caloriesKey, userData.calories);
    _preferences.setInt(_budgetKey, userData.budget);

    _preferences.setInt(_weightKey, userData.weight);
    _preferences.setInt(_heightKey, userData.height);
    _preferences.setInt(_ageKey, userData.age);
    _preferences.setString(_genderKey, userData.gender.name.toLowerCase());
    _preferences.setString(
        _activityLevelKey, userData.activity.name.toLowerCase());

    _preferences.setBool(_isFirstLaunchKey, userData.isFirstLaunch);
  }
}

// SettingsRepository prover used by rest of the app.
final settingsRepositoryProvider =
    FutureProvider<SettingsRepository>((ref) async {
  final settingsRepository = SettingsRepository();
  //await settingsRepository.loadSettings();
  return settingsRepository;
});
