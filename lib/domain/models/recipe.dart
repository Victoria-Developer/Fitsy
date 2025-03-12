class Recipe {
  int id = 0; // db id
  int? dayId;
  String? mealType; // breakfast, lunch etc
  String? name;
  String? instructions;
  int? calories;
  double? price;

  Recipe({this.dayId, this.mealType, this.name, this.instructions, this.calories, this.price});
}