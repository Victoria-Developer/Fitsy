import '../enums/activity.dart';
import '../enums/gender.dart';

class Settings {
  int days;
  int budget;
  int weight;
  int height;
  int age;
  int calories;
  bool isFirstLaunch;
  Gender gender;
  Activity activity;

  Settings({
    this.days = 1,
    this.budget = 100,
    this.weight = 55,
    this.height = 165,
    this.age = 20,
    this.calories = 1900,
    this.isFirstLaunch = true,
    this.gender = Gender.female,
    this.activity = Activity.moderate,
  });

  copyWith(Settings settings) {
    days = settings.days;
    budget = settings.budget;
    weight = settings.weight;
    height = settings.height;
    age = settings.age;
    calories = settings.calories;
    isFirstLaunch = settings.isFirstLaunch;
    gender = settings.gender;
    activity = settings.activity;
  }
}
