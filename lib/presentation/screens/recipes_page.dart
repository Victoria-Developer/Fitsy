import 'package:fitsy/presentation/widgets/visibility_component.dart';
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
  int currentPageIndex = 0;
  int pagesLength = 0;
  final controller = PageController();

  final AssetImage placeholderImage =
      AssetImage('assets/images/recipe-icon-placeholder.png');
  final AssetImage loadingImage = AssetImage('assets/images/loading-icon.gif');

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

  final daysButtonsStyle = GoogleFonts.ebGaramond(
    fontSize: 18,
  );

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
              return const Text("No menu plans found.");
            }
            pagesLength = mealPlans.length;
            return Column(
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.72,
                    child: PageView.builder(
                      controller: controller,
                      onPageChanged: (page) {
                        setState(() {
                          currentPageIndex = page;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      physics: const PageScrollPhysics(),
                      itemCount: mealPlans.length,
                      itemBuilder: (_, index) {
                        return _buildMealPlanCard(mealPlans[index]);
                      },
                    )),
                _buildDaysButtons(),
                if (notifier.shouldWarn())
                  Text("Settings updated — click 'New plan'.",
                      style: TextStyle(
                        color: Colors.red,
                      ))
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Wrap(alignment: WrapAlignment.center, children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                notifier.clearAndFetch();
              },
              child: const Text("New plan"),
            ))
      ]),
    );
  }

  SizedBox _buildMealPlanCard(List<Recipe> mealPlan) {
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
                  _buildRecipeImage(recipe.imgUrl),
                  SizedBox(height: 15),
                  Text(recipe.mealType ?? "Meal", style: titleStyle),
                  SizedBox(height: 10),
                  Text(recipe.name ?? "Unnamed meal",
                      style: titleStyle, textAlign: TextAlign.center),
                  SizedBox(height: 10),
                  Text(
                      "Calories ${recipe.calories ?? "unknown"}. "
                      "Price ${recipe.price ?? "unknown"} \$.",
                      style: mealInfoStyle),
                  SizedBox(height: 20),
                  if (recipe.instructions != null)
                    VisibilityComponent(instructions: recipe.instructions!),
                  SizedBox(height: 10),
                ]);
              }).toList())
            ],
          ),
        )));
  }

  Widget _buildRecipeImage(String? imgUrl) {
    return FadeInImage(
      image: NetworkImage(imgUrl ?? ""),
      placeholder: loadingImage,
      imageErrorBuilder: (context, error, stackTrace) {
        // fallback when the network image fails
        return Image(
            image: placeholderImage,
            width: 200,
            height: 200,
            fit: BoxFit.cover);
      },
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }

  Widget _buildDaysButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < pagesLength; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(40, 40),
                  padding: const EdgeInsets.all(5),
                  backgroundColor: currentPageIndex == i
                      ? Colors.green
                      : Colors.grey.shade300,
                  foregroundColor:
                      currentPageIndex == i ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    currentPageIndex = i;
                  });
                  controller.animateToPage(
                    currentPageIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text("Day ${i + 1}", style: daysButtonsStyle),
              ),
            ),
        ],
      ),
    );
  }
}
