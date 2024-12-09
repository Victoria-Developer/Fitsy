import 'dart:convert';
import 'dart:developer';

import 'package:fitsy/auth/secrets.dart';
import 'package:http/http.dart' as http;
import '../models/meal_plan.dart';
import 'gemini_model.dart';

Future<http.Response?> sendHttpRequest(String httpRoute,
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

Future<List<MealPlan>> sendGeminiRequest(String prompt) async {
  var url = "https://generativelanguage.googleapis.com/v1beta/models/"
      "${GeminiModel.flashLatestStable.name}:generateContent?key=$geminiApiKey";
  var response = await sendHttpRequest(url, buildGeminiRequestBody(prompt));
  if (response != null) {
    return parseJsonResponse(response);
  } else {
    return [];
  }
}

Future<List<MealPlan>> parseJsonResponse(http.Response response) async{
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

String buildGeminiRequestBody(String prompt) {
  final Map<String, dynamic> requestBody = {
    "system_instruction": {
      "parts": [
        {"text": ""}
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
