import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_color.dart';
import 'package:movies_app/utils/app_style.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
      appBarTheme: AppBarTheme(
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColor.yellow),
        titleTextStyle: AppStyle.reglur16yellow,
        backgroundColor: AppColor.blackColor,
      ),
      scaffoldBackgroundColor: AppColor.blackColor,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColor.transparent),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      )
      )
  );

}