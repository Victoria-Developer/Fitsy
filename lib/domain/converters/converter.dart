import '../../data/entities/recipe_entity.dart';
import '../models/recipe.dart';

Recipe fromEntityToDTO(RecipeEntity recipeEntity) {
  return Recipe(
      mealType: recipeEntity.mealType,
      dayId: recipeEntity.dayId,
      name: recipeEntity.name,
      instructions: recipeEntity.instructions,
      calories: recipeEntity.calories,
      price: recipeEntity.price);
}

Recipe fromJsonToDTO(Map<String, dynamic> json) {
  return Recipe(
    mealType: json['meal_type'],
    dayId: json['day_id'],
    name: json['recipe_name'],
    instructions: json['recipe'],
    calories: json['calories'],
    price: (json['usd_price'] as num).toDouble(),
  );
}

RecipeEntity fromJsonToDbEntity(Map<String, dynamic> json) {
  return RecipeEntity(
    mealType: json['meal_type'],
    dayId: json['day_id'],
    name: json['recipe_name'],
    instructions: json['recipe'],
    calories: json['calories'],
    price: (json['usd_price'] as num).toDouble(),
  );
}