// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Title`
  String get title {
    return Intl.message('Title', name: 'title', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forget Password`
  String get forgetPassword {
    return Intl.message(
      'Forget Password',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't Have Account?`
  String get DontHaveAcc {
    return Intl.message(
      'Don\'t Have Account?',
      name: 'DontHaveAcc',
      desc: '',
      args: [],
    );
  }

  /// `Create one!`
  String get createOne {
    return Intl.message('Create one!', name: 'createOne', desc: '', args: []);
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Already Have Account ? `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already Have Account ? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `Current Password`
  String get Current_Password {
    return Intl.message(
      'Current Password',
      name: 'Current_Password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get New_Password {
    return Intl.message(
      'New Password',
      name: 'New_Password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get Confirm_New_Password {
    return Intl.message(
      'Confirm New Password',
      name: 'Confirm_New_Password',
      desc: '',
      args: [],
    );
  }

  /// `Pick Avatar`
  String get Pick_Avatar {
    return Intl.message('Pick Avatar', name: 'Pick_Avatar', desc: '', args: []);
  }

  /// `Reset Password`
  String get Reset_Password {
    return Intl.message(
      'Reset Password',
      name: 'Reset_Password',
      desc: '',
      args: [],
    );
  }

  /// `Start Watching Now`
  String get StartWatchingNow {
    return Intl.message(
      'Start Watching Now',
      name: 'StartWatchingNow',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Login with Google`
  String get loginWithGoogle {
    return Intl.message(
      'Login with Google',
      name: 'loginWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Explore Now`
  String get explorenow {
    return Intl.message('Explore Now', name: 'explorenow', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Reset Password`
  String get reset_password {
    return Intl.message(
      'Reset Password',
      name: 'reset_password',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get Delete_Account {
    return Intl.message(
      'Delete Account',
      name: 'Delete_Account',
      desc: '',
      args: [],
    );
  }

  /// `Update Data`
  String get Update_Data {
    return Intl.message('Update Data', name: 'Update_Data', desc: '', args: []);
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Avatar`
  String get Avatar {
    return Intl.message('Avatar', name: 'Avatar', desc: '', args: []);
  }

  /// `Create Account`
  String get Create_Account {
    return Intl.message(
      'Create Account',
      name: 'Create_Account',
      desc: '',
      args: [],
    );
  }

  /// `Find Your Next  Favorite Movie Here`
  String get find_your_next_favorite_movie_Here {
    return Intl.message(
      'Find Your Next  Favorite Movie Here',
      name: 'find_your_next_favorite_movie_Here',
      desc: '',
      args: [],
    );
  }

  /// `Get access to a huge library of  movies to suit all tastes. You will surely like it.`
  String get Get_access_to_ahuge {
    return Intl.message(
      'Get access to a huge library of  movies to suit all tastes. You will surely like it.',
      name: 'Get_access_to_ahuge',
      desc: '',
      args: [],
    );
  }

  /// `Discover Movies`
  String get Discover_Movies {
    return Intl.message(
      'Discover Movies',
      name: 'Discover_Movies',
      desc: '',
      args: [],
    );
  }

  /// `Explore All Genres`
  String get Explore_All_Genres {
    return Intl.message(
      'Explore All Genres',
      name: 'Explore_All_Genres',
      desc: '',
      args: [],
    );
  }

  /// `Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.`
  String get Discover_movies_from_every_genre {
    return Intl.message(
      'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
      name: 'Discover_movies_from_every_genre',
      desc: '',
      args: [],
    );
  }

  /// `Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.`
  String get Explore_avast_collection {
    return Intl.message(
      'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
      name: 'Explore_avast_collection',
      desc: '',
      args: [],
    );
  }

  /// `Create Watchlists`
  String get Create_Watchlists {
    return Intl.message(
      'Create Watchlists',
      name: 'Create_Watchlists',
      desc: '',
      args: [],
    );
  }

  /// `Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.`
  String get Save_movies_to_your_watchlist {
    return Intl.message(
      'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
      name: 'Save_movies_to_your_watchlist',
      desc: '',
      args: [],
    );
  }

  /// `Rate, Review, and Learn`
  String get RateReviewandLearn {
    return Intl.message(
      'Rate, Review, and Learn',
      name: 'RateReviewandLearn',
      desc: '',
      args: [],
    );
  }

  /// `Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.`
  String get Shareyourthoughts {
    return Intl.message(
      'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
      name: 'Shareyourthoughts',
      desc: '',
      args: [],
    );
  }

  /// `Verify Email`
  String get VerifyEmail {
    return Intl.message(
      'Verify Email',
      name: 'VerifyEmail',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
