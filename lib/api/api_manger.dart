import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/api/api_model/movieResponse.dart';
import 'package:movies_app/api/endpoints.dart';

class ApiManager {
  static Future<MovieResponse> getMovies() async {
    try {
      Uri url = Uri.https(Endpoint.serverName, Endpoint.ApiName);
      var response = await http.get(url);
      return MovieResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
