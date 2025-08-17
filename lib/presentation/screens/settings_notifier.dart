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
  bool isDataSaved = true;
  bool hasDataChanged = false;

  @override
  Future<Settings> build() async {
    _settingsRepo = await ref.read(settingsRepositoryProvider.future);
    userData = await _settingsRepo.loadSettings();
    _originalUserData.copyWith(userData);
    return userData;
  }

  _onChange<T>(T oldValue, T newValue, void Function(T) update) {
    update(newValue);
    isDataSaved = oldValue == newValue;
    state = AsyncData(userData);
  }

  setUseAI(bool useAI) =>
      _onChange(_originalUserData.useAI, useAI, (v) => userData.useAI = v);

  setDays(int days) =>
      _onChange(_originalUserData.days, days, (v) => userData.days = v);

  setGender(Gender gender) =>
      _onChange(_originalUserData.gender, gender, (v) => userData.gender = v);

  setActivity(Activity activity) =>
      _onChange(_originalUserData.activity, activity, (v) => userData.activity = v);

  setAge(int age) =>
      _onChange(_originalUserData.age, age, (v) => userData.age = v);

  setWeight(int weight) =>
      _onChange(_originalUserData.weight, weight, (v) => userData.weight = v);

  setHeight(int height) =>
      _onChange(_originalUserData.height, height, (v) => userData.height = v);

  setBudget(int budget) =>
      _onChange(_originalUserData.budget, budget, (v) => userData.budget = v);

  saveSettings() async {
    if (userData.isFirstLaunch) {
      userData.isFirstLaunch = false;
    }
    _originalUserData.copyWith(userData);
    _settingsRepo.saveSettings(userData);
    isDataSaved = true;
    hasDataChanged = true;
    state = AsyncData(userData);
  }

  reset() {
    isDataSaved = true;
    userData.copyWith(_originalUserData);
    state = AsyncData(userData);
  }
}