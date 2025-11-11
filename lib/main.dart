import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/onBorading/onBoradingItem.dart';
import 'package:movies_app/onBorading/onBoradingScrean.dart';
import 'package:movies_app/ui/home/home_screen.dart';
import 'package:movies_app/ui/profile_tab/reset_password/reset_password.dart';
import 'package:movies_app/ui/profile_tab/update_profile/update_profile.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_theme.dart';

import 'auth/forget_password/forget_password.dart';
import 'auth/login_screen/login_screen.dart';
import 'auth/register_screen/register_screen.dart';
import 'ui/home_tab/home_tab.dart';

void main() {
  runApp(MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale("en"),
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: AppRoute.homeScreen,
      routes: {
        AppRoute.home_tab: (context) => HomeTab(),
        AppRoute.loginScreen: (context) => LoginScreen(),
        AppRoute.onborading: (context) => OnBoradingScrean(),
        AppRoute.OnBoradingItem: (context) => OnBoradingItem(),
        AppRoute.registerScreen: (context) => RegisterScreen(),
        AppRoute.updateProfile: (context) => UpdateProfile(),
        AppRoute.resetPassword: (context) => ResetPassword(),
        AppRoute.forgetPassword: (context) => ForgetPassword(),
        AppRoute.homeScreen: (context) => HomeScreen(),
      },
      theme: AppTheme.theme,
    );
  }
}
