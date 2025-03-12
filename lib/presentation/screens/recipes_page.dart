import 'dart:async';

import 'package:fitsy/data/repositories/recipes_repository.dart';
import 'package:fitsy/data/repositories/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../domain/models/recipe.dart';

class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  final StreamController<List<List<Recipe>>> recipesController =
      StreamController();
  late final Stream<List<List<Recipe>>> _stream = recipesController.stream;
  late RecipesRepository recipesRepository;
  late SettingsRepository settings;

  @override
  void initState() {
    _initRecipes();
    super.initState();
  }

  _initRecipes() async {
    recipesRepository = await ref.read(mealPlansRepositoryProvider.future);
    settings = await ref.read(settingsRepositoryProvider.future);

    final dbPlans = await recipesRepository.getDatabaseMealPlans();
    if (dbPlans.isEmpty) {
      _fetchRecipes();
    } else {
      recipesController.add(dbPlans);
    }
  }

  _fetchRecipes() async {
    List<List<Recipe>>? mealPlans = await recipesRepository.fetchMeals(
        settings.days, settings.calories, settings.budget);
    recipesController.sink.add(mealPlans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder<List<List<Recipe>>>(
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

  SizedBox _buildMealPlanCard(List<Recipe> mealPlan) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Day ${mealPlan.first.dayId}"),
              Column(
                  children: mealPlan.map((recipe) {
                return Column(children: [
                  Text(recipe.mealType.toString()),
                  Text(recipe.name.toString()),
                  Text(recipe.instructions.toString()),
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
