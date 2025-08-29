import 'dart:convert';

import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../auth/secrets.dart';
import '../../../domain/models/recipe.dart';
import '../api/gemini_api.dart';
import '../api/http_request.dart';
import '../api/images_api.dart';

class RemoteRecipesRepository {
  Future<List<Recipe>> fetchMeals(
      int daysNumber, int calories, int budget, bool useAI) async {
    List<Recipe> dtos = useAI
        ? await _fetchGeminiMeals(daysNumber, calories, budget)
        : await _fetchSupabaseMeals(daysNumber, calories, budget);

    return dtos;
  }

  Future<List<Recipe>> _fetchSupabaseMeals(
      int daysNumber, int calories, int budget) async {
    final pricePerServing = budget ~/ 3;
    final caloriesPerServing = calories ~/ 3;

    /* Replace with single backend api call */

    Future<List<Recipe>> fetchAndFill(String tag, String type) async {
      final response = await getHttpRequest(
        '$supabaseURL/rest/v1/recipes?'
        'price=lte.$pricePerServing&calories=lte.$caloriesPerServing&$type=eq.true',
        {
          'apikey': supabaseAnonKey,
          'Authorization': 'Bearer $supabaseAnonKey',
          'Accept': 'application/json',
        },
      );
      if (response == null) return [];

      try {
        final List data = jsonDecode(response.body);
        data.shuffle();
        final selected = data.take(daysNumber).toList();

        final filled = List.generate(
          daysNumber,
          (i) => selected[i % selected.length],
        );

        return filled
            .asMap()
            .entries
            .map((entry) => _fromSupabaseJsonToDTO(
                  entry.value,
                  type,
                  entry.key + 1,
                ))
            .toList();
      } catch (e) {
        return [];
      }
    }

    final breakfasts = await fetchAndFill('breakfast', 'Breakfast');
    final lunches = await fetchAndFill('main course', 'Lunch');
    final dinners = await fetchAndFill('main course', 'Dinner');

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
            .map(_fromGeminiJsonToDTO))
        .toList();

    List<Future<void>> imageFutures = [];
    for (var recipe in recipes) {
      if (recipe.name != null) {
        final future = fetchImage(recipe.name!, (img) => {recipe.imgUrl = img});
        imageFutures.add(future);
      }
    }
    // Waits for all async image fetches to complete
    await Future.wait(imageFutures);

    return recipes;
  }

  Recipe _fromGeminiJsonToDTO(Map<String, dynamic> json) {
    return Recipe(
      mealType: json['meal_type'],
      dayId: json['day_id'],
      name: json['recipe_name'],
      instructions: json['recipe'],
      calories: json['calories'],
      price: (json['usd_price'] as num).toDouble(),
    );
  }

  Recipe _fromSupabaseJsonToDTO(
      Map<String, dynamic> json, String? mealType, int dayId) {
    return Recipe(
        mealType: mealType ?? json['type'],
        dayId: dayId,
        name: json['title'],
        instructions: json['instructions'],
        calories: (json['calories'] as num).toInt(),
        price: (json['price'] as num).toDouble(),
        imgUrl: json['image']);
  }
}

// RecipesRepository provider used by rest of the app.
final remoteRecipesRepositoryProvider =
    Provider<RemoteRecipesRepository>((ref) {
  return RemoteRecipesRepository();
});
