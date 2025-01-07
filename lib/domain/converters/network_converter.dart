import 'package:fitsy/data/entities/meal_plan_entity.dart';
import 'package:fitsy/data/entities/recipe_entity.dart';

import '../../data/database/objectbox.g.dart';
import '../../domain/models/recipe.dart';
import '../models/meal_plan.dart';

Recipe recipeFromJson(Map<String, dynamic> json) {
  return Recipe(
    recipeId: json['id'],
    name: json['recipe_name'],
    instructions: json['recipe'],
    calories: json['calories'],
    price: (json['usd_price'] as num).toDouble(),
  );
}

MealPlan mealPlanFromJson(String dayId, List<dynamic> json) {
  List<Recipe> recipes = List.empty(growable: true);
  for (var mealJson in json) {
    recipes.add(recipeFromJson(mealJson));
  }
  return MealPlan(dayId: int.parse(dayId), recipes: recipes);
}

MealPlanEntity mealPlanEntityFromJson(String dayId, List<dynamic> json) {
  ToMany<RecipeEntity> recipes = ToMany<RecipeEntity>();
  for (var mealJson in json) {
    recipes.add(recipeEntityFromJson(mealJson));
  }
  return MealPlanEntity(dayId: int.parse(dayId), recipes: recipes);
}

RecipeEntity recipeEntityFromJson(Map<String, dynamic> json) {
  return RecipeEntity(
    recipeId: json['id'],
    name: json['recipe_name'],
    instructions: json['recipe'],
    calories: json['calories'],
    price: (json['usd_price'] as num).toDouble(),
  );
}
