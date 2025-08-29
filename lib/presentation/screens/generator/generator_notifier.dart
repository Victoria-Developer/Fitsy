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
  late SettingsNotifier _settingsNotifier;

  @override
  Future<List<List<Recipe>>> build() async {
    final (localRepo, recipes) =
        await ref.read(localRecipesRepositoryProvider.future);
    _localRecipesRepo = localRepo;
    _remoteRecipesRepo = ref.read(remoteRecipesRepositoryProvider);

    _settingsNotifier = await ref.read(settingsProvider.notifier);
    _settings = _settingsNotifier.userData;

    return recipes.isEmpty
        ? await _fetchMealPlans()
        : _groupRecipesByDayId(recipes);
  }

  Future<List<List<Recipe>>> _fetchMealPlans() async {
    _settingsNotifier.hasDataChanged = false;
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
    state = const AsyncLoading();
    await fetchNewMealPlans();
  }

  bool hasSettingsDataChanged() {
    return _settingsNotifier.hasDataChanged;
  }
}

final generatorProvider =
    AsyncNotifierProvider<GeneratorNotifier, List<List<Recipe>>>(
        GeneratorNotifier.new);
