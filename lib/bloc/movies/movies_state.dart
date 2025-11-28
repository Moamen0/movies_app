// lib/bloc/movies/movies_state.dart

class MovieItem {
  final int id;
  final String title;
  final String? image;
  final double? rating;
  final DateTime addedAt;

  MovieItem({
    required this.id,
    required this.title,
    this.image,
    this.rating,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'rating': rating,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory MovieItem.fromJson(Map<String, dynamic> json) {
    return MovieItem(
      id: json['id'] as int,
      title: json['title'] as String,
      image: json['image'] as String?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }
}

class MoviesState {
  final List<MovieItem> watchlist;
  final List<MovieItem> history;
  final bool isLoading;

  MoviesState({
    this.watchlist = const [],
    this.history = const [],
    this.isLoading = false,
  });

  MoviesState copyWith({
    List<MovieItem>? watchlist,
    List<MovieItem>? history,
    bool? isLoading,
  }) {
    return MoviesState(
      watchlist: watchlist ?? this.watchlist,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool isInWatchlist(int movieId) {
    return watchlist.any((movie) => movie.id == movieId);
  }

  bool isInHistory(int movieId) {
    return history.any((movie) => movie.id == movieId);
  }
}