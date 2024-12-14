import 'package:flutter/material.dart';

import '../../data/entities/meal_plan.dart';
import '../../data/network/http_request.dart';

class PlanGeneratorPage extends StatefulWidget {
  const PlanGeneratorPage({
    super.key,
    required this.title,
    required this.days,
    required this.calories,
    required this.budget,
  });

  final String title;
  final int days;
  final int calories;
  final int budget;

  @override
  State<PlanGeneratorPage> createState() => _PlanGeneratorPageState();
}

class _PlanGeneratorPageState extends State<PlanGeneratorPage> {
  late Future<List<MealPlan>> recipesList;

  @override
  void initState() {
    _fetchRecipes();
    super.initState();
  }

  _fetchRecipes() async {
    var requestBody = buildRequestBody(
        buildPrompt(widget.days, widget.calories, widget.budget));
    recipesList = sendGeminiRequest(requestBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<List<MealPlan>>(
      future: recipesList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const PageScrollPhysics(), // Snapping effect
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
    )));
  }

  SizedBox _buildMealPlanCard(MealPlan mealPlan) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Day ${mealPlan.dayId}"),
              Column(
                  children: mealPlan.recipes.map((recipe) {
                return Column(children: [
                  // Text(recipe.recipeId.toString()),
                  Text(recipe.name!),
                  Text(recipe.instructions!),
                  Text("${recipe.calories.toString()} calories"),
                  Text("${recipe.price.toString()} \$"),
                  const Divider(height: 50, thickness: 1)
                ]);
              }).toList())
            ],
          ),
        )));
  }
}
