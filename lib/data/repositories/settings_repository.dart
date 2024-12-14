import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/settings.dart';

class SettingsRepository {
  static final SettingsRepository _instance = SettingsRepository._internal();

  static SettingsRepository get instance => _instance;

  late final SharedPreferences _preferences;

  final String _daysKey = "days";
  final String _caloriesKey = "calories";
  final String _budgetKey = "budget";

  SettingsRepository._internal();

  Future<Settings> loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    int days = _preferences.getInt(_daysKey) ?? 1;
    int calories = _preferences.getInt(_caloriesKey) ?? 1400;
    int budget = _preferences.getInt(_budgetKey) ?? 100;
    return Settings(days: days, calories: calories, budget: budget);
  }

  saveDays(int days) async {
    _preferences.setInt(_daysKey, days);
  }

  saveCalories(int calories) async {
    _preferences.setInt(_caloriesKey, calories);
  }

  saveBudget(int budget) async {
    _preferences.setInt(_budgetKey, budget);
  }
}
