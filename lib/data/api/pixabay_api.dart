import 'package:http/http.dart';

import '../../auth/secrets.dart';
import 'http_request.dart';

Future<Response?> fetchPixabayImage(String query) async {
  var url = "https://pixabay.com/api/?key=$pixabayApiKey&q=$query=photo"
      "&image_type=photo&category=food";
  var response = await getHttpRequest(url, {});
  if (response != null) {
    return response;
  } else {
    return null;
  }
}