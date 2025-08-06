import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/models/recipe.dart';
import 'meal_pans_notifier.dart';

class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    final mealPlansAsync = ref.watch(mealPlansProvider);
    final notifier = ref.read(mealPlansProvider.notifier);

    return Scaffold(
      body: Center(
        child: mealPlansAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (e, st) =>
              const Text("Error happened while generating recipes."),
          data: (mealPlans) {
            if (mealPlans.isEmpty) {
              return const Text("You don't have any menu plans yet.");
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const PageScrollPhysics(),
              itemCount: mealPlans.length,
              itemBuilder: (_, index) {
                return _buildMealPlanCard(mealPlans[index]);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                notifier.clearAndFetch();
              },
              child: const Icon(Icons.refresh, size: 30),
            ),
          ],
        ),
      )
    );
  }

  SizedBox _buildMealPlanCard(List<Recipe> mealPlan) {
    final placeholderImg = "https://foodservice-rewards.com/cdn/shop/"
        "t/262/assets/fsr-placeholder.png?v=45093109498714503231652397781";

    final dayStyle = GoogleFonts.ebGaramond(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    );

    final titleStyle = GoogleFonts.ebGaramond(
      fontWeight: FontWeight.bold,
    );

    final mealInfoStyle = GoogleFonts.ebGaramond(
      fontStyle: FontStyle.italic,
    );

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text("Day ${mealPlan.first.dayId}", style: dayStyle),
              SizedBox(height: 10),
              Column(
                  children: mealPlan.map((recipe) {
                return Column(children: [
                  const Divider(height: 50, thickness: 1),
                  SizedBox(height: 10),
                  Image.network(
                    recipe.imgUrl ?? placeholderImg,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 15),
                  Text(recipe.mealType ?? "Meal", style: titleStyle),
                  SizedBox(height: 10),
                  Text(recipe.name ?? "Unnamed meal", style: titleStyle),
                  SizedBox(height: 10),
                  Text("Calories ${recipe.calories.toString()}. "
                      "Price ${recipe.price.toString()} \$.", style: mealInfoStyle),
                  SizedBox(height: 10),
                  Text(recipe.instructions.toString(),
                      textAlign: TextAlign.center, softWrap: true),
                  SizedBox(height: 10),
                ]);
              }).toList())
            ],
          ),
        )));
  }
}
