import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Riverpod(keepAlive: true)
class SettingsRepository {
  late final SharedPreferences _preferences;

  final String _daysKey = "days";
  final String _caloriesKey = "calories";
  final String _budgetKey = "budget";
  final String _isFirstLaunchKey = "is_first_launch";

  late int days, calories, budget;
  late bool isFirstLaunch;

  loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    days = _preferences.getInt(_daysKey) ?? 1;
    calories = _preferences.getInt(_caloriesKey) ?? 1400;
    budget = _preferences.getInt(_budgetKey) ?? 100;
    isFirstLaunch = _preferences.getBool(_isFirstLaunchKey) ?? true;
  }

  setFirstLaunch(bool isFirstLaunch) async {
    this.isFirstLaunch = isFirstLaunch;
    _preferences.setBool(_isFirstLaunchKey, isFirstLaunch);
  }

  setDays(int days) async {
    this.days = days;
    _preferences.setInt(_daysKey, days);
  }

  setCalories(int calories) async {
    this.calories = calories;
    _preferences.setInt(_caloriesKey, calories);
  }

  setBudget(int budget) async {
    this.budget = budget;
    _preferences.setInt(_budgetKey, budget);
  }
}

// SettingsRepository prover used by rest of the app.
final settingsRepositoryProvider =
    FutureProvider<SettingsRepository>((ref) async {
  final settingsRepository = SettingsRepository();
  await settingsRepository.loadSettings();
  return settingsRepository;
});
