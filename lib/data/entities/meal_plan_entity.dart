import 'package:fitsy/data/entities/recipe_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class MealPlanEntity {
  @Id()
  int id = 0;
  int dayId;
  @Backlink("mealPlan")
  ToMany<RecipeEntity> recipes;

  MealPlanEntity({required this.dayId, required this.recipes});
}
