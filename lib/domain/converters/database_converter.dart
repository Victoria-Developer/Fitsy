import 'package:fitsy/domain/models/meal_plan.dart';

import '../../data/entities/meal_plan_entity.dart';
import '../../data/entities/recipe_entity.dart';
import '../models/recipe.dart';

MealPlan fromMealPlanEntity(MealPlanEntity menuPlanEntity) {
  return MealPlan(
    dayId: menuPlanEntity.dayId,
    recipes: menuPlanEntity.recipes
        .map((recipeEntity) => fromRecipeEntity(recipeEntity))
        .toList(),
  );
}

Recipe fromRecipeEntity(RecipeEntity recipeEntity) {
  return Recipe(
      recipeId: recipeEntity.recipeId,
      name: recipeEntity.name,
      instructions: recipeEntity.instructions,
      calories: recipeEntity.calories,
      price: recipeEntity.price);
}
