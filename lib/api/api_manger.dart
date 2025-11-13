import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/api/endpoints.dart';

import 'api_model/MoviesResponse.dart';

class ApiManager {
  static Future<MoviesResponse> getMovies() async {
    try {
      Uri url = Uri.https(Endpoint.serverName, Endpoint.ApiName);
      var response = await http.get(url);
      return MoviesResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
