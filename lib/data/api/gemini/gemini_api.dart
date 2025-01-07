import 'package:fitsy/auth/secrets.dart';
import 'package:http/http.dart';

import '../http_request.dart';
import 'gemini_model.dart';

Future<Response?> sendRequest(String requestBody) async {
  var url = "https://generativelanguage.googleapis.com/v1beta/models/"
      "${GeminiModel.flashLatestStable.name}:generateContent?key=$geminiApiKey";
  var response = await sendHttpRequest(url, requestBody);
  if (response != null) {
    return response;
  } else {
    return null;
  }
}