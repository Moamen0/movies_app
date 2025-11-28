
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/bloc/movies/movies_event.dart';
import 'package:movies_app/bloc/movies/movies_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoviesBloc extends Bloc<MoviesEvent, MoviesState> {
  static const String _watchlistKey = 'watchlist';
  static const String _historyKey = 'history';

  MoviesBloc() : super(MoviesState()) {
    on<LoadMoviesEvent>(_onLoadMovies);
    on<AddToWatchlistEvent>(_onAddToWatchlist);
    on<RemoveFromWatchlistEvent>(_onRemoveFromWatchlist);
    on<AddToHistoryEvent>(_onAddToHistory);
    on<ClearHistoryEvent>(_onClearHistory);
  }

  Future<void> _onLoadMovies(
    LoadMoviesEvent event,
    Emitter<MoviesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      print("📚 Loading movies from storage...");
      final prefs = await SharedPreferences.getInstance();

      // Load watchlist
      final watchlistJson = prefs.getString(_watchlistKey);
      List<MovieItem> watchlist = [];
      if (watchlistJson != null) {
        final List<dynamic> list = json.decode(watchlistJson);
        watchlist = list.map((item) => MovieItem.fromJson(item)).toList();
        print("✅ Watchlist loaded: ${watchlist.length} movies");
      }

      // Load history
      final historyJson = prefs.getString(_historyKey);
      List<MovieItem> history = [];
      if (historyJson != null) {
        final List<dynamic> list = json.decode(historyJson);
        history = list.map((item) => MovieItem.fromJson(item)).toList();
        print("✅ History loaded: ${history.length} movies");
      }

      emit(state.copyWith(
        watchlist: watchlist,
        history: history,
        isLoading: false,
      ));
    } catch (e) {
      print("❌ Error loading movies: $e");
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlistEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      print("➕ Adding to watchlist: ${event.title}");
      
      // Check if already in watchlist
      if (state.isInWatchlist(event.movieId)) {
        print("⚠️ Movie already in watchlist");
        return;
      }

      final newMovie = MovieItem(
        id: event.movieId,
        title: event.title,
        image: event.image,
        rating: event.rating,
        addedAt: DateTime.now(),
      );

      final updatedWatchlist = [...state.watchlist, newMovie];
      
      // Save to SharedPreferences
      await _saveWatchlist(updatedWatchlist);

      emit(state.copyWith(watchlist: updatedWatchlist));
      print("✅ Added to watchlist successfully");
    } catch (e) {
      print("❌ Error adding to watchlist: $e");
    }
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlistEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      print("➖ Removing from watchlist: ${event.movieId}");
      
      final updatedWatchlist = state.watchlist
          .where((movie) => movie.id != event.movieId)
          .toList();

      await _saveWatchlist(updatedWatchlist);

      emit(state.copyWith(watchlist: updatedWatchlist));
      print("✅ Removed from watchlist successfully");
    } catch (e) {
      print("❌ Error removing from watchlist: $e");
    }
  }

  Future<void> _onAddToHistory(
    AddToHistoryEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      print("📖 Adding to history: ${event.title}");
      
      // Remove if already in history (to re-add at top)
      final updatedHistory = state.history
          .where((movie) => movie.id != event.movieId)
          .toList();

      final newMovie = MovieItem(
        id: event.movieId,
        title: event.title,
        image: event.image,
        rating: event.rating,
        addedAt: DateTime.now(),
      );

      // Add at the beginning (most recent first)
      updatedHistory.insert(0, newMovie);

      // Keep only last 50 items
      if (updatedHistory.length > 50) {
        updatedHistory.removeRange(50, updatedHistory.length);
      }

      await _saveHistory(updatedHistory);

      emit(state.copyWith(history: updatedHistory));
      print("✅ Added to history successfully");
    } catch (e) {
      print("❌ Error adding to history: $e");
    }
  }

  Future<void> _onClearHistory(
    ClearHistoryEvent event,
    Emitter<MoviesState> emit,
  ) async {
    try {
      print("🗑️ Clearing history...");
      await _saveHistory([]);
      emit(state.copyWith(history: []));
      print("✅ History cleared");
    } catch (e) {
      print("❌ Error clearing history: $e");
    }
  }

  Future<void> _saveWatchlist(List<MovieItem> watchlist) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = watchlist.map((movie) => movie.toJson()).toList();
      await prefs.setString(_watchlistKey, json.encode(jsonList));
    } catch (e) {
      print("❌ Error saving watchlist: $e");
    }
  }

  Future<void> _saveHistory(List<MovieItem> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = history.map((movie) => movie.toJson()).toList();
      await prefs.setString(_historyKey, json.encode(jsonList));
    } catch (e) {
      print("❌ Error saving history: $e");
    }
  }
}