import 'package:objectbox/objectbox.dart';

@Entity()
class RecipeEntity {
  @Id()
  int id = 0; // db id
  int? dayId;
  String? mealType; // breakfast, lunch etc
  String? name;
  String? instructions;
  int? calories;
  double? price;
  String? imgUrl;

  RecipeEntity(
      {this.dayId,
      this.mealType,
      this.name,
      this.instructions,
      this.calories,
      this.price,
      this.imgUrl});
}
