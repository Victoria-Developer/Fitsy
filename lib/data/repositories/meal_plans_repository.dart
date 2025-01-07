import 'package:fitsy/domain/usecases/gemini_menu_generator.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dart:convert';
import 'dart:developer';

import '../../domain/converters/database_converter.dart';
import '../../domain/converters/network_converter.dart';
import '../../domain/models/meal_plan.dart';
import '../database/app_box.dart';
import '../entities/meal_plan_entity.dart';

@Riverpod(keepAlive: true)
class MealPlansRepository {
  late AppBox appBox;

  MealPlansRepository({required this.appBox});

  Future<List<MealPlan>> fetchMeals(
      int daysNumber, int calories, int budget) async {
    Response? response = await generateMenu(daysNumber, calories, budget);
    if (response == null) return [];

    // Parse the JSON response
    final jsonData = jsonDecode(response.body);

    final text = jsonData['candidates']?[0]['content']?['parts']?[0]['text'];
    log(text);
    if (text == null) return [];

    final parsedData = jsonDecode(text) as Map<String, dynamic>;

    // Parse JSON into MealPlanEntity objects and populate database
    List<MealPlanEntity> mealPlanEntities = parsedData.entries
        .map((entry) => mealPlanEntityFromJson(entry.key, entry.value))
        .toList();
    appBox.replaceAllMealPlans(mealPlanEntities);

    // Parse JSON into MealPlan DTO objects
    List<MealPlan> mealPlans = parsedData.entries
        .map((entry) => mealPlanFromJson(entry.key, entry.value))
        .toList();

    return mealPlans;
  }

  Future<List<MealPlan>> getDatabaseMealPlans() async {
    List<MealPlanEntity> mealPlanEntities = await appBox.getAllMealPlans();
    return mealPlanEntities
        .map((entity) => fromMealPlanEntity(entity))
        .toList();
  }

}

// MealPlansRepository prover used by rest of the app.
final mealPlansRepositoryProvider =
    FutureProvider<MealPlansRepository>((ref) async {
  final appBox = await AppBox.create();
  return MealPlansRepository(appBox: appBox);
});
