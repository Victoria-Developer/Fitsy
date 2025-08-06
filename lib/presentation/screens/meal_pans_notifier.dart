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

  @override
  Future<List<List<Recipe>>> build() async {
    _repo = await ref.read(recipesRepositoryProvider.future);
    _settings = await ref.read(settingsProvider.future);

    final dbPlans = await _repo.getDatabaseMealPlans();
    if (dbPlans.isEmpty) {
      return await fetchNewMealPlans();
    } else {
      return dbPlans;
    }
  }

  Future<List<List<Recipe>>> fetchNewMealPlans() async {
    List<String> names = [];
    state.value?.forEach((list) {
      for (var recipe in list) {
        names.add(recipe.name??"");
      }
    });
    final newPlans = await _repo.fetchMeals(
      _settings.days,
      _settings.calories,
      _settings.budget,
      names.toString()
    );

    state = AsyncData(newPlans);
    return newPlans;
  }

  void clearAndFetch() async {
    state = const AsyncLoading();
    await fetchNewMealPlans();
  }
}