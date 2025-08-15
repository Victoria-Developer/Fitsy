import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../auth/secrets.dart';

Future<Response?> fetchFitsyRecipes(
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
    return response;
  } else {
    return null;
  }
}

Future<Response?> fetchFitsyRecipeImages(String query) async {
  final response = await http.get(
    Uri.parse('$supabaseURL/rest/v1/rpc/match_recipe?'
        'query=${Uri.encodeComponent(query)}'),
    headers: {
      'apikey': supabaseAnonKey,
      'Authorization': 'Bearer $supabaseAnonKey',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
  );
  if (response.statusCode == 200) {
    return response;
  } else {
    return null;
  }
}