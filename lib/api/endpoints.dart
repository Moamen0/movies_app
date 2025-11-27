class Endpoint {
  /*
  https://yts.mx/api/v2/list_movies.json
  https://yts.mx/api/v2/movie_details.json?movie_id=10	
  https://yts.lt/api/v2/movie_details.json?movie_id=15&with_images=true&with_cast=true
  https://yts.lt/api/v2/list_movies.json
   */
  static const String serverName = 'yts.lt';
  static const String ApiName = '/api/v2/list_movies.json';
  static const String movieSearchApi = '/api/v2/list_movies.json';
  static const String movieDetailsApiName = '/api/v2/movie_details.json';
  static const String movieSuggestionsApiName = '/api/v2/movie_suggestions.json';
}
