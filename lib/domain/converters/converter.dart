import '../../data/entities/recipe_entity.dart';
import '../models/recipe.dart';

Recipe fromEntityToDTO(RecipeEntity recipeEntity) {
  return Recipe(
      mealType: recipeEntity.mealType,
      dayId: recipeEntity.dayId,
      name: recipeEntity.name,
      instructions: recipeEntity.instructions,
      calories: recipeEntity.calories,
      price: recipeEntity.price,
      imgUrl: recipeEntity.imgUrl);
}

RecipeEntity fromDTOToEntity(Recipe dto) {
  return RecipeEntity(
    mealType: dto.mealType,
    dayId: dto.dayId,
    name: dto.name,
    instructions: dto.instructions,
    calories: dto.calories,
    price: dto.price,
    imgUrl: dto.imgUrl
  );
}

Recipe fromGeminiJsonToDTO(Map<String, dynamic> json) {
  return Recipe(
    mealType: json['meal_type'],
    dayId: json['day_id'],
    name: json['recipe_name'],
    instructions: json['recipe'],
    calories: json['calories'],
    price: (json['usd_price'] as num).toDouble(),
  );
}

Recipe fromSupabaseJsonToDTO(
    Map<String, dynamic> json, String? mealType, int dayId) {
  return Recipe(
    mealType: mealType ?? json['type'],
    dayId: dayId,
    name: json['title'],
    instructions: json['instructions'],
    calories: (json['calories'] as num).toInt(),
    price: (json['price'] as num).toDouble(),
    imgUrl: json['image']
  );
}
