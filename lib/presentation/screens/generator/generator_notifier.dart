import 'package:fitsy/data/remote/repositories/remote_recipes_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/local/repositories/local_recipes_repository.dart';
import '../../../domain/models/recipe.dart';
import '../../../domain/models/settings.dart';
import '../settings/settings_notifier.dart';

@Riverpod(keepAlive: true)
class GeneratorNotifier extends AsyncNotifier<List<List<Recipe>>> {
  late LocalRecipesRepository _localRecipesRepo;
  late RemoteRecipesRepository _remoteRecipesRepo;
  late Settings _settings;
  bool hasSettingsChanged = false;

  @override
  Future<List<List<Recipe>>> build() async {
    final (localRepo, recipes) =
        await ref.read(localRecipesRepositoryProvider.future);
    _localRecipesRepo = localRepo;
    _remoteRecipesRepo = ref.read(remoteRecipesRepositoryProvider);

    _settings = await ref.read(settingsProvider.future);

    ref.listen(settingsProvider, (prev, next) {
      final data = next.value;
      if (data != null && prev != next) {
        hasSettingsChanged = true;
        _settings = data;
      }
    });

    return recipes.isEmpty
        ? await _fetchMealPlans()
        : _groupRecipesByDayId(recipes);
  }

  Future<List<List<Recipe>>> _fetchMealPlans() async {
    final newPlans = await _remoteRecipesRepo.fetchMeals(
        _settings.days, _settings.calories, _settings.budget, _settings.useAI);
    final plans = _groupRecipesByDayId(newPlans);
    _localRecipesRepo.insertMealPlans(newPlans);
    return plans;
  }

  List<List<Recipe>> _groupRecipesByDayId(List<Recipe> recipes) {
    Map<int, List<Recipe>> groupedRecipes = {};
    for (var recipe in recipes) {
      if (recipe.dayId == null) continue;
      groupedRecipes.putIfAbsent(recipe.dayId!, () => []).add(recipe);
    }
    return groupedRecipes.values.toList();
  }

  fetchNewMealPlans() async {
    state = AsyncData(await _fetchMealPlans());
  }

  void clearAndFetch() async {
    hasSettingsChanged = false;
    state = const AsyncLoading();
    await fetchNewMealPlans();
  }
}

final generatorProvider =
    AsyncNotifierProvider<GeneratorNotifier, List<List<Recipe>>>(
        GeneratorNotifier.new);
