import 'package:fitsy/presentation/screens/settings_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/recipes_repository.dart';
import '../../domain/models/recipe.dart';
import '../../domain/models/settings.dart';

final mealPlansProvider =
AsyncNotifierProvider<MealPlansNotifier, List<List<Recipe>>>(MealPlansNotifier.new);

class MealPlansNotifier extends AsyncNotifier<List<List<Recipe>>> {
  late RecipesRepository _repo;
  late Settings _settings;
  late SettingsNotifier _settingsNotifier;

  @override
  Future<List<List<Recipe>>> build() async {
    _repo = await ref.read(recipesRepositoryProvider.future);
    _settingsNotifier = await ref.read(settingsProvider.notifier);
    _settings = _settingsNotifier.userData;

    final dbPlans = await _repo.getDatabaseMealPlans();
    if (dbPlans.isEmpty) {
      return await fetchNewMealPlans();
    } else {
      return dbPlans;
    }
  }

  Future<List<List<Recipe>>> fetchNewMealPlans() async {
    _settingsNotifier.hasDataChanged = false;
    final newPlans = await _repo.fetchMeals(
      _settings.days,
      _settings.calories,
      _settings.budget,
      _settings.useAI
    );

    state = AsyncData(newPlans);
    return newPlans;
  }

  void clearAndFetch() async {
    state = const AsyncLoading();
    await fetchNewMealPlans();
  }

  bool hasSettingsDataChanged() {
    return  _settingsNotifier.hasDataChanged;
  }

}