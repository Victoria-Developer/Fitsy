class Recipe {
  int id = 0; // db id
  int? dayId;
  String? mealType; // breakfast, lunch etc
  String? name;
  String? instructions;
  int? calories;
  double? price;
  String? imgUrl;

  Recipe(
      {this.dayId,
      this.mealType,
      this.name,
      this.instructions,
      this.calories,
      this.price,
      this.imgUrl});
}
