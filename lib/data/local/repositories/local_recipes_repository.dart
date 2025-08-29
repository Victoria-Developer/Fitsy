import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/models/recipe.dart';
import '../database/app_box.dart';
import '../entities/recipe_entity.dart';

@Riverpod(keepAlive: true)
class LocalRecipesRepository {
  late AppBox appBox;

  LocalRecipesRepository({required this.appBox});

  Future<List<Recipe>> getDatabaseMealPlans() async {
    List<RecipeEntity> recipesEntities = await appBox.getAllMealPlans();
    List<Recipe> recipes =
        recipesEntities.map((entity) => fromEntityToDTO(entity)).toList();
    return recipes;
  }

  insertMealPlans(List<Recipe> recipes) async {
    List<RecipeEntity> entities =
        recipes.map((dto) => fromDTOToEntity(dto)).toList();
    appBox.replaceAllMealPlans(entities);
  }

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
        imgUrl: dto.imgUrl);
  }
}

final localRecipesRepositoryProvider =
FutureProvider<(LocalRecipesRepository, List<Recipe>)>((ref) async {
  final appBox = await AppBox.create();
  final repo = LocalRecipesRepository(appBox: appBox);
  final recipes = await repo.getDatabaseMealPlans();
  return (repo, recipes);
});
