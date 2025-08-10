import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../auth/secrets.dart';

Future<Response?> fetchRecipes(
    int pricePerServing, int caloriesPerServing, String type) async {
  final response = await http.get(
    Uri.parse('$supabaseURL/rest/v1/recipes?'
        'price=lte.$pricePerServing&calories=lte.$caloriesPerServing&$type=eq.true'),
    headers: {
      'apikey': supabaseAnonKey,
      'Authorization': 'Bearer $supabaseAnonKey',
      'Accept': 'application/json',
    },
  );
  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    print("Recipes: $data");
    return response;
  } else {
    print("Error: ${response.statusCode} - ${response.body}");
    return null;
  }
}
