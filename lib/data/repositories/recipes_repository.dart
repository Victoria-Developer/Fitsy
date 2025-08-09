import 'package:fitsy/data/api/pixabay_api.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dart:convert';

import '../../domain/converters/converter.dart';
import '../../domain/models/recipe.dart';
import '../api/gemini/gemini_api.dart';
import '../database/app_box.dart';
import '../entities/recipe_entity.dart';

@Riverpod(keepAlive: true)
class RecipesRepository {
  late AppBox appBox;
  final SupabaseClient supabase = Supabase.instance.client;

  RecipesRepository({required this.appBox});

  Future<List<List<Recipe>>> getDatabaseMealPlans() async {
    List<RecipeEntity> recipesEntities = await appBox.getAllMealPlans();
    List<Recipe> recipes =
        recipesEntities.map((entity) => fromEntityToDTO(entity)).toList();
    return _groupRecipesByDayId(recipes);
  }

  Future<List<List<Recipe>>> fetchMeals(
      int daysNumber, int calories, int budget, bool useAI) async {
    List<Recipe> dtos = useAI
        ? await _fetchGeminiMeals(daysNumber, calories, budget)
        : await _fetchSupabaseMeals(daysNumber, calories, budget);
    List<RecipeEntity> entities =
        dtos.map((dto) => fromDTOToEntity(dto)).toList();
    appBox.replaceAllMealPlans(entities);
    return _groupRecipesByDayId(dtos);
  }

  Future<List<Recipe>> _fetchSupabaseMeals(
      int daysNumber, int calories, int budget) async {
    final pricePerServing = budget ~/ 3;
    final caloriesPerServing = calories ~/ 3;

    final baseQuery = supabase
        .from("recipes")
        .select()
        .lte('price', pricePerServing.toInt())
        .lte('calories', caloriesPerServing.toInt());

    Future<List<Recipe>> fetchAndFill(String type) async {
      final data = await baseQuery.ilike('type', '%$type%');
      data.shuffle();
      final selected = data.take(daysNumber).toList();

      final filled = List.generate(
        daysNumber,
        (i) => selected[i % selected.length],
      );

      return filled
          .asMap()
          .entries
          .map((entry) => fromSupabaseJsonToDTO(
                entry.value,
                type,
                entry.key + 1,
              ))
          .toList();
    }

    final breakfasts = await fetchAndFill('Breakfast');
    final lunches = await fetchAndFill('Lunch');
    final dinners = await fetchAndFill('Dinner');

    return [...breakfasts, ...lunches, ...dinners];
  }

  Future<List<Recipe>> _fetchGeminiMeals(daysNumber, calories, budget) async {
    Response? response = await generateMenu(daysNumber, calories, budget);
    if (response == null) return [];

    final jsonData = jsonDecode(response.body);
    final text = jsonData['candidates']?[0]['content']?['parts']?[0]['text'];
    if (text == null) return [];

    final parsedData = jsonDecode(text) as Map<String, dynamic>;
    List<Recipe> recipes = parsedData.entries
        .expand((entry) => (entry.value as List)
            .cast<Map<String, dynamic>>()
            .map(fromGeminiJsonToDTO))
        .toList();
    await _fetchPixabayImages(recipes);

    return recipes;
  }

  Future<void> _fetchPixabayImages(List<Recipe> dtos) async {
    List<Future<void>> imageFutures = [];

    Future<void> fetchImage(Recipe dto) async {
      Response? imgResponse = await getImage(dto.name!);
      if (imgResponse != null) {
        var jsonImgData = jsonDecode(imgResponse.body);
        var imgUrl = jsonImgData['hits']?[0]['webformatURL'];
        dto.imgUrl = imgUrl;
      }
    }

    for (var dto in dtos) {
      if (dto.name != null) {
        imageFutures.add(fetchImage(dto));
      }
    }

    await Future.wait(
        imageFutures); // Waits for all async image fetches to complete
  }
}

List<List<Recipe>> _groupRecipesByDayId(List<Recipe> recipes) {
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
