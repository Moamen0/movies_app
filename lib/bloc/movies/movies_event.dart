abstract class MoviesEvent {}

class LoadMoviesEvent extends MoviesEvent {}

class AddToWatchlistEvent extends MoviesEvent {
  final int movieId;
  final String title;
  final String? image;
  final double? rating;

  AddToWatchlistEvent({
    required this.movieId,
    required this.title,
    this.image,
    this.rating,
  });
}

class RemoveFromWatchlistEvent extends MoviesEvent {
  final int movieId;

  RemoveFromWatchlistEvent(this.movieId);
}

class AddToHistoryEvent extends MoviesEvent {
  final int movieId;
  final String title;
  final String? image;
  final double? rating;

  AddToHistoryEvent({
    required this.movieId,
    required this.title,
    this.image,
    this.rating,
  });
}

class ClearHistoryEvent extends MoviesEvent {}