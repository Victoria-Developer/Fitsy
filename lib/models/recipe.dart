class Recipe {
  int? id;
  String? recipeName;
  String? recipe;
  int? calories;
  double? price;

  Recipe({this.id, this.recipeName, this.recipe, this.calories, this.price});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      recipeName: json['recipe_name'],
      recipe: json['recipe'],
      calories: json['calories'],
      price: (json['usd_price'] as num).toDouble(),
    );
  }

}
