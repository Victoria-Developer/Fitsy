import 'package:fitsy/domain/models/recipe.dart';

class MealPlan{
  int id = 0;
  int dayId;

  List<Recipe> recipes;

  MealPlan({required this.dayId, required this.recipes});
}
