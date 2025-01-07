import 'package:objectbox/objectbox.dart';
import 'meal_plan_entity.dart';

@Entity()
class RecipeEntity {
  @Id()
  int id = 0; // db id
  int? recipeId; // breakfast is 0, lunch is 1 etc
  String? name;
  String? instructions;
  int? calories;
  double? price;

  final mealPlan = ToOne<MealPlanEntity>();

  RecipeEntity({
    this.recipeId, this.name,
    this.instructions, this.calories, this.price
  });
}
