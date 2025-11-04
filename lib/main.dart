import 'package:flutter/material.dart';
import 'package:movies_app/onBorading/onBoradingScrean.dart';
import 'package:movies_app/utils/app_route.dart';

void main() {
  runApp(MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoute.onborading,
      routes: {AppRoute.onborading: (context) => OnBoradingScrean()},
      themeMode: ThemeMode.dark,
    );
  }
}
