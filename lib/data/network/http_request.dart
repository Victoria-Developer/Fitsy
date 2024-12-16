import 'dart:convert';
import 'dart:developer';

import 'package:fitsy/auth/secrets.dart';
import 'package:http/http.dart' as http;


import '../entities/meal_plan.dart';
import 'gemini_model.dart';

Future<http.Response?> _sendHttpRequest(
    String httpRoute, String requestBody) async {
  try {
    final response = await http.post(
      Uri.parse(httpRoute),
      headers: {
        "Content-Type": "application/json",
      },
      body: requestBody,
    );
    if (response.statusCode == 200) {
      log(response.body);
      return response;
    } else {
      log("Error: ${response.statusCode}, ${response.body}");
      return null;
    }
  } catch (e) {
    log(e.toString());
    return null;
  }
}

Future<List<MealPlan>> sendGeminiRequest(String requestBody) async {
  var url = "https://generativelanguage.googleapis.com/v1beta/models/"
      "${GeminiModel.flashLatestStable.name}:generateContent?key=$geminiApiKey";
  var response = await _sendHttpRequest(url, requestBody);
  if (response != null) {
    return _parseJsonResponse(response);
  } else {
    return [];
  }
}

Future<List<MealPlan>> _parseJsonResponse(http.Response response) async {
  // Parse the JSON response
  final jsonData = jsonDecode(response.body);

  final text = jsonData['candidates']?[0]['content']?['parts']?[0]['text'];
  log(text);
  if (text == null) return [];

  // Parse JSON into MealPlan objects
  final parsedData = jsonDecode(text) as Map<String, dynamic>;
  final List<MealPlan> mealPlans = parsedData.entries
      .map((entry) => MealPlan.fromJson(entry.key, entry.value))
      .toList();

  return mealPlans;
}

String buildRequestBody(String prompt) {
  final Map<String, dynamic> requestBody = {
    "system_instruction": {
      "parts": [
        {"text": "Follow instructions in prompt. Follow the DRY principle (Don't repeat yourself)."}
      ]
    },
    "contents": [
      {
        "parts": [
          {"text": prompt}
        ]
      }
    ],
    "generationConfig": {
      "response_mime_type": "application/json",
    }
  };

  return jsonEncode(requestBody);
}

String buildPrompt(int daysNumber, int calories, int budget) {
  // add checks for unrealistic calories and budget like 0 calories and 0 usd.
  return """
    Calories amount per day should be no more than $calories. 
    Costs per day in usd should be no more than $budget.
    Give me recipes for $daysNumber days for 3 meals using this JSON schema. 
    Replace 'day_id' with the corresponding day number 
    (starting from `1` even if there is only one day). 
    Replace 'meal_id' with an actual index 
    (starting from `0` even if there is only one meal).
    Describe recipes in detail with all ingredients measurements.
    Don't mention meal name like 'breakfast' in 'recipe_name'.
    {
        "day_id":{
              [{ 
                'id': {'type': 'int'},
                'recipe_name': {'type': 'string'},
                'recipe': {'type': 'string'},
                'calories': {'type': 'int'},
                'usd_price': {'type': 'int'}
              }]
        }
    }    
    """;
}
