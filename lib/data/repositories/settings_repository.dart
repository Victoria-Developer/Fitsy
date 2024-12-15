import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static final SettingsRepository _instance = SettingsRepository._internal();

  static SettingsRepository get instance => _instance;

  late final SharedPreferences _preferences;

  final String _daysKey = "days";
  final String _caloriesKey = "calories";
  final String _budgetKey = "budget";
  final String _isFirstLaunchKey = "is_first_launch";

  late int days, calories, budget;
  late bool isFirstLaunch;

  SettingsRepository._internal();

  loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    days = _preferences.getInt(_daysKey) ?? 1;
    calories = _preferences.getInt(_caloriesKey) ?? 1400;
    budget = _preferences.getInt(_budgetKey) ?? 100;
    isFirstLaunch = _preferences.getBool(_isFirstLaunchKey) ?? true;
    if (isFirstLaunch == true) {
      _preferences.setBool(_isFirstLaunchKey, false);
    }
  }

  saveDays(int days) async {
    this.days = days;
    _preferences.setInt(_daysKey, days);
  }

  saveCalories(int calories) async {
    this.calories = calories;
    _preferences.setInt(_caloriesKey, calories);
  }

  saveBudget(int budget) async {
    this.budget = budget;
    _preferences.setInt(_budgetKey, budget);
  }
}
