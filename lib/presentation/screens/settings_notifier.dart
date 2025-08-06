import 'package:fitsy/domain/enums/gender.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../../data/repositories/settings_repository.dart';
import '../../domain/enums/activity.dart';
import '../../domain/models/settings.dart';

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, Settings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<Settings> {
  late SettingsRepository _settingsRepo;
  final Settings _originalUserData = Settings();
  Settings userData = Settings();

  @override
  Future<Settings> build() async {
    _settingsRepo = await ref.read(settingsRepositoryProvider.future);
    userData = await _settingsRepo.loadSettings();
    _originalUserData.copyWith(userData);
    return userData;
  }

  setDays(int days){
    userData.days = days;
    state = AsyncData(userData);
  }

  setGender(Gender gender){
    userData.gender = gender;
    state = AsyncData(userData);
  }

  setActivity(Activity activity){
    userData.activity = activity;
    state = AsyncData(userData);
  }

  setAge(int age){
    userData.age = age;
    state = AsyncData(userData);
  }

  setWeight(int weight){
    userData.weight = weight;
    state = AsyncData(userData);
  }

  setHeight(int height){
    userData.height = height;
    state = AsyncData(userData);
  }

  setBudget(int budget){
    userData.budget = budget;
    state = AsyncData(userData);
  }

  setFirstLaunch(bool isFirstLaunch){
    userData.isFirstLaunch = isFirstLaunch;
    state = AsyncData(userData);
  }

  saveSettings() async {
    _originalUserData.copyWith(userData);
    _settingsRepo.saveSettings(userData);
  }

  reset() {
    userData.copyWith(_originalUserData);
    state = AsyncData(userData);
  }
}
