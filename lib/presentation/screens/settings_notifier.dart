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
  bool shouldWarnAboutChanges = false;

  @override
  Future<Settings> build() async {
    _settingsRepo = await ref.read(settingsRepositoryProvider.future);
    userData = await _settingsRepo.loadSettings();
    _originalUserData.copyWith(userData);
    return userData;
  }

  _onChange(Function action) {
    action();
    isDataSaved = false;
    state = AsyncData(userData);
  }

  setUseAI(bool useAI) {
    _onChange(() => userData.useAI = useAI);
  }

  setDays(int days) {
    _onChange(() => userData.days = days);
  }

  setGender(Gender gender) {
    _onChange(() => userData.gender = gender);
  }

  setActivity(Activity activity) {
    _onChange(() => userData.activity = activity);
  }

  setAge(int age) {
    _onChange(() => userData.age = age);
  }

  setWeight(int weight) {
    _onChange(() => userData.weight = weight);
  }

  setHeight(int height) {
    _onChange(() => userData.height = height);
  }

  setBudget(int budget) {
    _onChange(() => userData.budget = budget);
  }

  saveSettings() async {
    if (userData.isFirstLaunch) {
      userData.isFirstLaunch = false;
    }
    _originalUserData.copyWith(userData);
    _settingsRepo.saveSettings(userData);
    isDataSaved = true;
    shouldWarnAboutChanges = true;
    state = AsyncData(userData);
  }

  reset() {
    isDataSaved = true;
    userData.copyWith(_originalUserData);
    state = AsyncData(userData);
  }
}
