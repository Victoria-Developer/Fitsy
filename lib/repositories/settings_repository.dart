import 'package:fitsy/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepository {
  static final SettingsRepository _instance = SettingsRepository._internal();

  static SettingsRepository get instance => _instance;

  late final SharedPreferences _preferences;

  final String _daysKey = "days";
  final String _caloriesKey = "calories";
  final String _budgetKey = "budget";

  SettingsRepository._internal();

  Future<Settings> loadPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    int days = _preferences.getInt(_daysKey) ?? 1;
    int calories = _preferences.getInt(_caloriesKey) ?? 1400;
    int budget = _preferences.getInt(_budgetKey) ?? 100;
    return Settings(days: days, calories: calories, budget: budget);
  }

  Future<int> getDays() async {
    return _preferences.getInt(_daysKey) ?? 1;
  }

  Future setDays(int days) {
    return _preferences.setInt(_daysKey, days);
  }

  Future<int> getCalories() async {
    return _preferences.getInt(_caloriesKey) ?? 1400;
  }

  Future setCalories(int calories) {
    return _preferences.setInt(_caloriesKey, calories);
  }

  Future<int> getBudget() async {
    return _preferences.getInt(_budgetKey) ?? 100;
  }

  Future setBudget(int budget) {
    return _preferences.setInt(_budgetKey, budget);
  }
}
