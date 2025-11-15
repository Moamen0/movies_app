import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/api/endpoints.dart';

import 'api_model/MoviesResponse.dart';

class ApiManager {
  static Future<MoviesResponse> getMovies() async {
    try {
      Uri url = Uri.https(Endpoint.serverName, Endpoint.ApiName,
        {"sort_by": 'date_uploaded'}
      );
      var response = await http.get(url);
      return MoviesResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
  static Future<MoviesResponse> getMoviesByGenre(String genre) async {
    try {
      Uri url = Uri.https(Endpoint.serverName, Endpoint.ApiName,{
        "genre":genre,
        "sort_by":'rating'
      });
      var response = await http.get(url);
      return MoviesResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      rethrow;
    }
  }
}
