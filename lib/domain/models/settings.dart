import '../enums/activity.dart';
import '../enums/gender.dart';

class Settings {
  int days = 1,
      budget = 100,
      weight = 55,
      height = 165,
      age = 20,
      calories = 1900;
  bool isFirstLaunch = true;
  Gender gender = Gender.female;
  Activity activity = Activity.moderate;

  Settings();
}