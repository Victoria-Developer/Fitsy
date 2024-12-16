import 'dart:async';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../data/database/app_box.dart';
import '../../data/entities/meal_plan.dart';
import '../../data/network/http_request.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({
    super.key,
    required this.days,
    required this.calories,
    required this.budget,
  });

  final int days;
  final int calories;
  final int budget;

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final StreamController<List<MealPlan>> recipesController = StreamController();
  late Stream<List<MealPlan>> _stream;
  late AppBox appBox;

  @override
  void initState() {
    _initRecipes();
    super.initState();
  }

  _initRecipes() async {
    appBox = context.read<AppBox>();

    _stream = recipesController.stream;

    final dbPlans = await appBox.getAllMealPlans();
    if (dbPlans.isEmpty) {
      _fetchRecipes();
    } else {
      recipesController.add(dbPlans);
    }
  }

  _fetchRecipes() async {
    var requestBody = buildRequestBody(
        buildPrompt(widget.days, widget.calories, widget.budget));
    List<MealPlan> mealPlans = await sendGeminiRequest(requestBody);
    recipesController.sink.add(mealPlans);
    appBox.replaceAllMealPlans(mealPlans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder<List<MealPlan>>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return const CircularProgressIndicator();
            } else {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const PageScrollPhysics(), // Snapping effect
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  var data = snapshot.data![index];
                  return _buildMealPlanCard(data);
                },
              );
            }
          } else {
            return const Text(
                "Error happened while generating recipes. Please try again.");
          }
        },
      )),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            recipesController.sink.add([]);
            _fetchRecipes();
          },
          child: Text("Recalculate")),
    );
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
