import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/http_request.dart';
import '../widgets/recipe_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Recipe>> recipesList;

  @override
  void initState() {
    fetchRecipes();
    super.initState();
  }

  fetchRecipes() async {
    var prompt = """
    Give me a few dessert recipes this JSON schema:
        { 
          'id':{'type': 'int'},
          'recipe_name': {'type': 'string'},
          'recipe':{'type': 'string'},
          'calories'{'type': 'int'}
          'usd_price':{'type': 'int'}
        }
    """;
    recipesList = sendGeminiRequest(prompt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
            child: FutureBuilder<List<Recipe>>(
          future: recipesList,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.waiting
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(snapshot.data!.length, (index) {
                      var recipe = snapshot.data?[index];
                      return RecipeItem(
                        recipeName: recipe?.recipeName ?? "No name",
                        recipe: recipe?.recipe ?? "No recipe",
                        calories: recipe?.calories?? 0,
                        price: recipe?.price?? 0.0,
                      );
                    }));
          },
        )));
  }
}
