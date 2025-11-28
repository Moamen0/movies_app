import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movies_app/api/endpoints.dart';
import 'package:movies_app/model/Api_movie_Suggestions.dart';
import 'package:movies_app/model/Api_movie_deatils.dart';

import 'api_model/MoviesResponse.dart';

class ApiManager {
 static Future<MoviesResponse> getMovies() async {
    try {
      Uri url = Uri.https(
        Endpoint.serverName, 
        Endpoint.ApiName, 
        {"sort_by": 'date_uploaded'}
      );
      
      var response = await http.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
      
      final jsonData = jsonDecode(response.body);
      if (jsonData == null) {
        throw Exception('Invalid JSON response');
      }
      
      return MoviesResponse.fromJson(jsonData);
    } catch (e) {
      print('❌ getMovies Error: $e');
      rethrow;
    }
  }

    static Future<MoviesResponse> getMoviesByGenre(String genre) async {
    try {
      if (genre.isEmpty) {
        throw Exception('Genre cannot be empty');
      }
      
      Uri url = Uri.https(
        Endpoint.serverName, 
        Endpoint.ApiName,
        {"genre": genre, "sort_by": 'rating'}
      );
      
      var response = await http.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
      
      final jsonData = jsonDecode(response.body);
      return MoviesResponse.fromJson(jsonData);
    } catch (e) {
      print('❌ getMoviesByGenre Error: $e');
      rethrow;
    }
  }


  static Future<MovieModel> getMovieDetails(int movieId) async {
    try {
      if (movieId <= 0) {
        throw Exception('Invalid movie ID');
      }
      
      Uri url = Uri.https(
        Endpoint.serverName, 
        Endpoint.movieDetailsApiName, 
        {
          "movie_id": movieId.toString(),
          "with_images": "true",
          "with_cast": "true",
        }
      );
      
      var response = await http.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
      
      final jsonData = jsonDecode(response.body);
      
      // ⚠️ CRITICAL FIX: Check nested structure
      if (jsonData['data'] == null || jsonData['data']['movie'] == null) {
        throw Exception('Movie data not found');
      }
      
      return MovieModel.fromJson(jsonData['data']['movie']);
    } catch (e) {
      print('❌ getMovieDetails Error: $e');
      rethrow;
    }
  }
  

   static Future<List<MovieSuggestion>> getMovieSuggestions(int movieId) async {
    try {
      if (movieId <= 0) {
        throw Exception('Invalid movie ID');
      }
      
      Uri url = Uri.https(
        Endpoint.serverName,
        Endpoint.movieSuggestionsApiName,
        {"movie_id": movieId.toString()},
      );

      var response = await http.get(url);
      
      if (response.statusCode != 200) {
        print('⚠️ Suggestions not available: ${response.statusCode}');
        return []; 
      }
      
      var jsonData = jsonDecode(response.body);

      if (jsonData["data"] == null || jsonData["data"]["movies"] == null) {
        return [];
      }

      List movies = jsonData["data"]["movies"];
      return movies.map((e) => MovieSuggestion.fromJson(e)).toList();
    } catch (e) {
      print('❌ getMovieSuggestions Error: $e');
      return []; 
    }
  }

 static Future<MoviesResponse> getMoviesByGenreandPage(
      String genre, int page) async {
    try {
      if (genre.isEmpty) {
        throw Exception('Genre cannot be empty');
      }
      
      if (page <= 0) {
        throw Exception('Page must be positive');
      }
      
      Uri url = Uri.https(
        Endpoint.serverName,
        Endpoint.ApiName,
        {
          "genre": genre,
          "sort_by": "rating",
          "page": page.toString(),
        },
      );

      var response = await http.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
      
      return MoviesResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      print('❌ getMoviesByGenreandPage Error: $e');
      rethrow;
    }
  }
    static Future<MoviesResponse> getMoviesBy(String text) async {
    try {
      // Allow empty text for showing all movies
      if (text.trim().isEmpty) {
        print('⚠️ Empty search query, fetching all movies');
        return getMovies();
      }
      
      Uri url = Uri.https(
        Endpoint.serverName,
        Endpoint.movieSearchApi,
        {'query_term': text.trim()}
      );
      
      var response = await http.get(url);
      
      if (response.statusCode != 200) {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
      
      final jsonData = jsonDecode(response.body);
      return MoviesResponse.fromJson(jsonData);
    } catch (e) {
      print('❌ getMoviesBy Error: $e');
      rethrow;
    }
  }
}
