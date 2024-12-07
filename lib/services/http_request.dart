import 'dart:convert';
import 'dart:developer';

import 'package:fitsy/auth/secrets.dart';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';
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

Future<List<Recipe>> sendGeminiRequest(String prompt) async {
  var url = "https://generativelanguage.googleapis.com/v1beta/models/"
      "${GeminiModel.flashLatestStable.name}:generateContent?key=$geminiApiKey";
  var response = await sendHttpRequest(url, buildGeminiRequestBody(prompt));
  if (response != null) {
    return parseJsonResponse(response);
  } else {
    return [];
  }
}

Future<List<Recipe>> parseJsonResponse(http.Response response) async{
  // Parse the JSON response
  final jsonData = jsonDecode(response.body);

  // Extract the `text` field containing the JSON array
  final text = jsonData['candidates']?[0]['content']?['parts']?[0]['text'];
  if (text == null) return [];

  // Decode the text field into a List of Maps
  final recipesJson = jsonDecode(text) as List<dynamic>;

  // Map each JSON object to a Recipe
  final recipes = recipesJson.map((json) => Recipe.fromJson(json)).toList();

  for (var recipe in recipes) {
    log(recipe.recipe.toString());
  }

  return recipes;
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
