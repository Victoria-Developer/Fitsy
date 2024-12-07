import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  const RecipeItem({
    super.key,
    required this.recipeName,
    required this.recipe,
    required this.calories,
    required this.price,
  });

  final String recipeName;
  final String recipe;
  final int calories;
  final double price;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        child: Column(
          children: [
            Text(recipeName),
            Text(recipe),
            Text(calories.toString()),
            Text(price.toString())
          ]
        )
      ),
    );
  }
}
