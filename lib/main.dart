import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movies_app/bloc/locale/localization.dart';
import 'package:movies_app/bloc/profile/profile_bloc.dart';
import 'package:movies_app/generated/l10n.dart';
import 'package:movies_app/onBorading/onBoradingItem.dart';
import 'package:movies_app/onBorading/onBoradingScrean.dart';
import 'package:movies_app/ui/home/home_screen.dart';
import 'package:movies_app/ui/movie_details/movies_details_screen.dart';
import 'package:movies_app/ui/profile_tab/reset_password/reset_password.dart';
import 'package:movies_app/ui/profile_tab/update_profile/update_profile.dart';
import 'package:movies_app/utils/app_route.dart';
import 'package:movies_app/utils/app_theme.dart';
import 'auth/forget_password/forget_password.dart';
import 'auth/login_screen/login_screen.dart';
import 'auth/register_screen/register_screen.dart';
import 'ui/home_tab/home_tab.dart';

void main() {
  runApp(const MoviesApp());
}

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocaleCubit()),
        BlocProvider(create: (context) => ProfileBloc()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: locale, // Dynamic locale from LocaleCubit
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            initialRoute: AppRoute.homeScreen,
            routes: {
              AppRoute.home_tab: (context) => const HomeTab(),
              AppRoute.loginScreen: (context) => const LoginScreen(),
              AppRoute.onborading: (context) => const OnBoradingScrean(),
              AppRoute.OnBoradingItem: (context) => const OnBoradingItem(),
              AppRoute.registerScreen: (context) => const RegisterScreen(),
              AppRoute.updateProfile: (context) => const UpdateProfile(),
              AppRoute.resetPassword: (context) => const ResetPassword(),
              AppRoute.forgetPassword: (context) => const ForgetPassword(),
              AppRoute.homeScreen: (context) =>   HomeScreen(),
              AppRoute.movieDetailsScreen: (context) => MovieDetailsScreen(
                    movieId: ModalRoute.of(context)!.settings.arguments as int,
                  ),
            },
            theme: AppTheme.theme,
          );
        },
      ),
    );
  }
}