import 'dart:convert';

import 'package:fitsy/data/api/gemini/gemini_api.dart';
import 'package:http/http.dart';

Future<Response?> generateMenu(int daysNumber, int calories, int budget) async {
  String prompt = _buildMenuPrompt(daysNumber, calories, budget);
  String request = _buildJsonRequestBody(prompt);
  return await sendRequest(request);
}

String _buildJsonRequestBody(String prompt) {
  final Map<String, dynamic> requestBody = {
    "system_instruction": {
      "parts": [
        {
          "text":
              "Follow instructions in prompt. Don't repeat yourself."
        }
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

String _buildMenuPrompt(int daysNumber, int calories, int budget) {
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
    Do not repeat recipe names, and ensure that each recipe is distinct from others.
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
