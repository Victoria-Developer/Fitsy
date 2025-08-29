import 'dart:convert';

import 'package:http/http.dart';

import '../../../auth/secrets.dart';
import 'http_request.dart';

fetchImage(String keyWord, Function(String?) onFetch) async {
  // Fitsy recipe images api
  final fitsyResponse = await _fetchFitsyRecipeImages(keyWord);
  if (fitsyResponse != null) {
    final list = (jsonDecode(fitsyResponse.body) as List?) ?? [];
    if (list.isNotEmpty) {
      onFetch(list.first['img_url']);
    }
  }
  // Pixabay api
  final pixabayResponse = await _fetchPixabayImage(keyWord);
  if (pixabayResponse != null) {
    final data = jsonDecode(pixabayResponse.body);
    final hits = (data['hits'] as List?) ?? [];
    if (hits.isNotEmpty) {
      onFetch(hits.first['webformatURL']);
    }
  }
}

Future<Response?> _fetchFitsyRecipeImages(String query) async {
  return await getHttpRequest(
    '$supabaseURL/rest/v1/rpc/match_recipe?'
        'query=${Uri.encodeComponent(query)}',
    {
      'apikey': supabaseAnonKey,
      'Authorization': 'Bearer $supabaseAnonKey',
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    },
  );
}

Future<Response?> _fetchPixabayImage(String query) async {
  var url = "https://pixabay.com/api/?key=$pixabayApiKey&q=$query=photo"
      "&image_type=photo&category=food";
  return await getHttpRequest(url, {});
}