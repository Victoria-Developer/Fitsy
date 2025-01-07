class Recipe {
  int id = 0; // db id
  int? recipeId; // breakfast is 0, lunch is 1 etc
  String? name;
  String? instructions;
  int? calories;
  double? price;

  Recipe({this.recipeId, this.name, this.instructions, this.calories, this.price});
}