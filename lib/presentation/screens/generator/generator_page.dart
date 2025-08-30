import 'package:fitsy/presentation/widgets/dynamic_bottom_bar.dart';
import 'package:fitsy/presentation/widgets/visibility_component.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../domain/models/recipe.dart';
import '../../widgets/warning_widget.dart';
import 'generator_notifier.dart';

class GeneratorPage extends ConsumerStatefulWidget {
  const GeneratorPage({super.key});

  @override
  ConsumerState<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends ConsumerState<GeneratorPage> {
  int currentPageIndex = 0;
  int pagesLength = 0;
  final pageController = PageController();

  final AssetImage placeholderImage =
      AssetImage('assets/images/recipe-icon-placeholder.png');
  final AssetImage loadingImage = AssetImage('assets/images/loading-icon.gif');

  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(generatorProvider);
    final notifier = ref.read(generatorProvider.notifier);

    return Scaffold(
        body: SafeArea(
            child: dataAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (e, st) => const Center(
            child: Text("Error happened while generating recipes."),
          ),
          data: (mealPlans) {
            if (mealPlans.isEmpty) {
              return const Center(child: Text("No menu plans found."));
            }
            pagesLength = mealPlans.length;

            return Column(
              children: [
                WarningWidget(
                    isShown: notifier.hasSettingsChanged,
                    message:
                        "Settings updated! Generate your next meal."),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          onPageChanged: (page) {
                            setState(() {
                              currentPageIndex = page;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                          physics: const PageScrollPhysics(),
                          itemCount: mealPlans.length,
                          itemBuilder: (_, index) =>
                              _buildMealPlanCard(mealPlans[index]),
                        ),
                      ),
                      _buildDaysButtons(context),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
              ],
            );
          },
        )),
        bottomNavigationBar:  Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () => notifier.clearAndFetch(),
                child: const Text("New plan"),
              ),
            ),
            const DynamicBottomBar(), // your existing bottom bar
          ],
        ));
  }

  SizedBox _buildMealPlanCard(List<Recipe> mealPlan) {
    final mediumBodyTextTheme = Theme.of(context).textTheme.bodyMedium;
    final dayTitleStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );
    final titleStyle = mediumBodyTextTheme?.copyWith(
      fontWeight: FontWeight.bold,
    );
    final mealInfoStyle = mediumBodyTextTheme?.copyWith(
      fontStyle: FontStyle.italic,
    );

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
            child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text("Day ${mealPlan.first.dayId}", style: dayTitleStyle),
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
        // Placeholder when the network image fails
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

  Widget _buildDaysButtons(BuildContext context) {
    final daysButtonsStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < pagesLength; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(40, 40),
                  padding: const EdgeInsets.all(3),
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
                  pageController.animateToPage(
                    currentPageIndex,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: Text("${i + 1}", style: daysButtonsStyle),
              ),
            ),
        ],
      ),
    );
  }
}