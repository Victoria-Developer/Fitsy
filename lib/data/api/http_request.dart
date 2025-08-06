import 'package:http/http.dart' as http;

Future<http.Response?> sendHttpRequest(
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
      return response;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}


