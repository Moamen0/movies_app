import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_color.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
      scaffoldBackgroundColor: AppColor.blackColor,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColor.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      )
      )
  );

}