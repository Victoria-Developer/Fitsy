import 'dart:convert';
import 'dart:developer';

import 'package:fitsy/auth/secrets.dart';
import 'package:http/http.dart' as http;
import '../models/meal_plan.dart';
import 'gemini_model.dart';

Future<http.Response?> _sendHttpRequest(String httpRoute,
    String requestBody) async {
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

Future<List<MealPlan>> _parseJsonResponse(http.Response response) async{
  // Parse the JSON response
  final jsonData = jsonDecode(response.body);

  final text = jsonData['candidates']?[0]['content']?['parts']?[0]['text'];
  log(text);
  if (text == null) return [];

  // Decode JSON
  Map<String, dynamic> decodedText = jsonDecode(text);

  // Parse meal plans
  List<MealPlan> weeklyMealPlan = decodedText.entries.map((entry) {
    return MealPlan.fromJson(entry.key, entry.value);
  }).toList();

  return weeklyMealPlan;
}

String buildRequestBody(int daysNumber) {
  final Map<String, dynamic> requestBody = {
    "system_instruction": {
      "parts": [
        {"text": ""}
      ]
    },
    "contents": [
      {
        "parts": [
          {"text": _buildPrompt(daysNumber)}
        ]
      }
    ],
    "generationConfig": {
      "response_mime_type": "application/json",
    }
  };

  return jsonEncode(requestBody);
}

String _buildPrompt(int daysNumber){
  return """
    Give me recipes for $daysNumber days for meal names 'breakfast', 'lunch' and 'dinner'
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
}
