import 'package:fitsy/data/api/pixabay_api.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dart:convert';

import '../../domain/converters/converter.dart';
import '../../domain/models/recipe.dart';
import '../api/gemini/gemini_api.dart';
import '../database/app_box.dart';
import '../entities/recipe_entity.dart';

@Riverpod(keepAlive: true)
class RecipesRepository {
  late AppBox appBox;

  RecipesRepository({required this.appBox});

  Future<List<List<Recipe>>> fetchMeals(
      int daysNumber, int calories, int budget, String previousResult) async {
    Response? response =
        await generateMenu(daysNumber, calories, budget, previousResult);
    if (response == null) return [];

    // Parse the JSON response
    final jsonData = jsonDecode(response.body);

    final text = jsonData['candidates']?[0]['content']?['parts']?[0]['text'];
    if (text == null) return [];

    final parsedData = jsonDecode(text) as Map<String, dynamic>;

    List<RecipeEntity> recipeEntities = [];
    List<Recipe> recipes = [];

    for (var entry in parsedData.entries) {
      var recipeList = entry.value;
      for (var recipeJson in (recipeList as List)) {
        var entity = fromJsonToDbEntity(recipeJson);
        var dto = fromJsonToDTO(recipeJson);
        recipeEntities.add(entity);
        recipes.add(dto);
      }
    }

    await _getPixabayImages(recipeEntities, recipes);
    appBox.replaceAllMealPlans(recipeEntities);
    return groupRecipesByDayId(recipes);
  }

  Future<void> _getPixabayImages(List<RecipeEntity> entities, List<Recipe> dtos) async {
    List<Future<void>> imageFutures = [];

    for (int i = 0; i < dtos.length; i++) {
      final dto = dtos[i];
      final entity = entities[i];

      if (dto.name != null) {
        imageFutures.add(_fetchAndAssignImage(dto, entity));
      }
    }

    await Future.wait(
        imageFutures); // Waits for all async image fetches to complete
  }

  Future<void> _fetchAndAssignImage(Recipe dto, RecipeEntity entity) async {
    Response? imgResponse = await getImage(dto.name!);
    if (imgResponse != null) {
      var jsonImgData = jsonDecode(imgResponse.body);
      var imgUrl = jsonImgData['hits']?[0]['webformatURL'];
      entity.imgUrl = imgUrl;
      dto.imgUrl = imgUrl;
    }
  }

  Future<List<List<Recipe>>> getDatabaseMealPlans() async {
    List<RecipeEntity> recipesEntities = await appBox.getAllMealPlans();
    List<Recipe> recipes =
        recipesEntities.map((entity) => fromEntityToDTO(entity)).toList();
    return groupRecipesByDayId(recipes);
  }
}

List<List<Recipe>> groupRecipesByDayId(List<Recipe> recipes) {
  Map<int, List<Recipe>> groupedRecipes = {};
  for (var recipe in recipes) {
    if (recipe.dayId == null) continue;
    groupedRecipes.putIfAbsent(recipe.dayId!, () => []).add(recipe);
  }
  return groupedRecipes.values.toList();
}

// RecipesRepository provider used by rest of the app.
final recipesRepositoryProvider =
    FutureProvider<RecipesRepository>((ref) async {
  final appBox = await AppBox.create();
  return RecipesRepository(appBox: appBox);
});
