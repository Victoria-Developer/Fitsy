import 'package:fitsy/models/recipe.dart';

// Daily meal plan
class MealPlan {
  int dayId;
  Map<String, Recipe> meals;

  MealPlan({required this.dayId, required this.meals});

  factory MealPlan.fromJson(String dayId, Map<String, dynamic> json) {
    Map<String, Recipe> parsedMeals = {};
    json.forEach((mealName, mealJson) {
      parsedMeals[mealName] = Recipe.fromJson(mealJson);
    });
    return MealPlan(dayId: int.parse(dayId), meals: parsedMeals);
  }
}
