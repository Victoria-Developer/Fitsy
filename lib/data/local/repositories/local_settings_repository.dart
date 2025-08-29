import 'package:fitsy/domain/enums/activity.dart';
import 'package:fitsy/domain/enums/gender.dart';
import 'package:fitsy/domain/models/settings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Riverpod(keepAlive: true)
class LocalSettingsRepository {
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
  final String _useAIKey = "use_AI";

  Future<Settings> loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    Settings userData = Settings();

    _changeVal(_preferences.getInt(_daysKey), (val) => userData.days = val);
    _changeVal(
        _preferences.getInt(_caloriesKey), (val) => userData.calories = val);
    _changeVal(_preferences.getInt(_budgetKey), (val) => userData.budget = val);
    _changeVal(_preferences.getInt(_weightKey), (val) => userData.weight = val);
    _changeVal(_preferences.getInt(_heightKey), (val) => userData.height = val);
    _changeVal(_preferences.getInt(_ageKey), (val) => userData.age = val);
    _changeVal<String>(
      _preferences.getString(_genderKey),
      (val) => userData.gender = Gender.values.byName(val),
    );
    _changeVal<String>(
      _preferences.getString(_activityLevelKey),
      (val) => userData.activity = Activity.values.byName(val),
    );
    _changeVal(_preferences.getBool(_isFirstLaunchKey),
        (val) => userData.isFirstLaunch = val);

    _changeVal(_preferences.getBool(_useAIKey),
            (val) => userData.useAI = val);

    return userData;
  }

  void _changeVal<T>(T? value, void Function(T val) onChange) {
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
    _preferences.setBool(_useAIKey, userData.useAI);
  }
}

final localSettingsRepositoryProvider =
FutureProvider<(LocalSettingsRepository, Settings)>((ref) async {
  final repo = LocalSettingsRepository();
  final settings = await repo.loadSettings();
  return (repo, settings);
});