
import 'package:flutter/material.dart';

import '../models/meal_plan.dart';
import '../services/http_request.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<MealPlan>> recipesList;
  int selectedCardId = 0;

  @override
  void initState() {
    fetchRecipes();
    super.initState();
  }

  void setSelectedCardId(int id) {
    setState(() {
      selectedCardId = id;
    });
  }

  fetchRecipes() async {
    var prompt = """
    Give me recipes for 2 days for meal names 'breakfast', 'lunch' and 'dinner'
    using this JSON schema, replace 'day_id' with day number 
    starting from number '0' and replace 'meal_name' with an actual 
    name like 'lunch':
    {
        "day_id":{
              "meal_name":{ 
                'id':{'type': 'int'},
                'recipe_name': {'type': 'string'},
                'recipe':{'type': 'string'},
                'calories'{'type': 'int'}
                'usd_price':{'type': 'int'}
              }
        }
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
        )));
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
