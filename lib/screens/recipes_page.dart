

import 'package:flutter/material.dart';

import '../models/meal_plan.dart';
import '../services/http_request.dart';

class RecipesPage extends StatefulWidget {

  const RecipesPage({
    super.key,
    required this.title, required this.days,
  });

  final String title;
  final int days;

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late Future<List<MealPlan>> recipesList;

  @override
  void initState() {
    _fetchRecipes(widget.days);
    super.initState();
  }

  _fetchRecipes(int daysNumber) async {
    var prompt = buildRequestBody(daysNumber);
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
            child: FutureBuilder<List<MealPlan>>(
          future: recipesList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(), // this for snapping
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  var data = snapshot.data![index];
                  return _buildMealPlanCard(data);
                },
              );
            } else {
              return const Text("No data");
            }
          },
        )
        )
    );
  }

  SizedBox _buildMealPlanCard(MealPlan mealPlan) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          child: SingleChildScrollView(child: Column(
            children: [
              Text(mealPlan.dayId),
              Column(
                  children: mealPlan.meals.entries.map((entry) {
                    var title = entry.key;
                    var recipe = entry.value;
                    return Column(children: [
                      Text(title),
                      Text(recipe.recipeName!),
                      Text(recipe.recipe!),
                      Text(recipe.calories.toString()),
                      Text(recipe.price.toString()),
                      const Divider(height: 50, thickness: 1)
                    ]);
                  }).toList())
            ],
          ),)
        ));
  }
}
