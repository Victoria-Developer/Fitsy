import 'dart:async';

import 'package:fitsy/data/repositories/meal_plans_repository.dart';
import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../domain/models/meal_plan.dart';

class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  final StreamController<List<MealPlan>> recipesController = StreamController();
  late final Stream<List<MealPlan>> _stream = recipesController.stream;
  late MealPlansRepository menuRepository;
  late SettingsRepository settings;

  @override
  void initState() {
    _initRecipes();
    super.initState();
  }

  _initRecipes() async {
    menuRepository = await ref.read(mealPlansRepositoryProvider.future);
    settings = await ref.read(settingsRepositoryProvider.future);

    final dbPlans = await menuRepository.getDatabaseMealPlans();
    if (dbPlans.isEmpty) {
      _fetchRecipes();
    } else {
      recipesController.add(dbPlans);
    }
  }

  _fetchRecipes() async {
    List<MealPlan>? mealPlans = await menuRepository.fetchMeals(
        settings.days, settings.calories, settings.budget);
    recipesController.sink.add(mealPlans);
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
