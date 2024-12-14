import 'package:fitsy/data/entities/meal_plan.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Recipe {
  @Id()
  int id = 0; // db id
  int? recipeId; // breakfast is 0, lunch is 1 etc
  String? name;
  String? instructions;
  int? calories;
  double? price;

  final mealPlan = ToOne<MealPlan>();

  Recipe({this.recipeId, this.name, this.instructions, this.calories, this.price});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      recipeId: json['id'],
      name: json['recipe_name'],
      instructions: json['recipe'],
      calories: json['calories'],
      price: (json['usd_price'] as num).toDouble(),
    );
  }
}
