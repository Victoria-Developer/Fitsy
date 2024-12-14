import 'package:fitsy/data/entities/recipe.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class MealPlan {
  @Id()
  int id = 0;
  int dayId;

  @Backlink("mealPlan")
  final ToMany<Recipe> recipes = ToMany<Recipe>();

  MealPlan({required this.dayId});

  factory MealPlan.fromJson(String dayId, List<dynamic> json) {
    ToMany<Recipe> parsedMeals = ToMany<Recipe>();
    for (var mealJson in json) {
      parsedMeals.add(Recipe.fromJson(mealJson));
    }
    return MealPlan(dayId: int.parse(dayId))..recipes.addAll(parsedMeals);
  }
}
