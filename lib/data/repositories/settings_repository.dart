import 'package:fitsy/domain/enums/activity.dart';
import 'package:fitsy/domain/enums/gender.dart';
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

  late int days, budget, weight, height, age, calories;
  late bool isFirstLaunch;
  late Gender gender;
  late Activity activity;

  loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    days = _preferences.getInt(_daysKey) ?? 1;
    calories = _preferences.getInt(_caloriesKey) ?? 1775;
    budget = _preferences.getInt(_budgetKey) ?? 100;

    weight = _preferences.getInt(_weightKey) ?? 77;
    height = _preferences.getInt(_heightKey) ?? 180;
    age = _preferences.getInt(_ageKey) ?? 25;
    gender = Gender.values.byName(_preferences.getString(_genderKey) ?? "male");
    activity = Activity.values
        .byName(_preferences.getString(_activityLevelKey) ?? "light");

    isFirstLaunch = _preferences.getBool(_isFirstLaunchKey) ?? true;
  }

  // Mifflin-St Jeor Equation
  calculate() {
    double calories;
    if (gender == Gender.male) {
      calories = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      calories = 10 * weight + 6.25 * height - 5 * age - 161;
    }
    calories *= activity.multiplier;
    setCalories(calories.toInt());
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

  setWeight(int weight) async {
    this.weight = weight;
    _preferences.setInt(_weightKey, weight);
  }

  setHeight(int height) async {
    this.height = height;
    _preferences.setInt(_heightKey, height);
  }

  setAge(int age) async {
    this.age = age;
    _preferences.setInt(_ageKey, age);
  }

  setGender(Gender gender) async {
    this.gender = gender;
    _preferences.setString(_genderKey, gender.name.toLowerCase());
  }

  setActivity(Activity activity) async {
    this.activity = activity;
    _preferences.setString(_activityLevelKey, activity.name.toLowerCase());
  }
}

// SettingsRepository prover used by rest of the app.
final settingsRepositoryProvider =
    FutureProvider<SettingsRepository>((ref) async {
  final settingsRepository = SettingsRepository();
  await settingsRepository.loadSettings();
  return settingsRepository;
});
