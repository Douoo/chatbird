import 'package:chatbird/styles/colors.dart';
import 'package:flutter/material.dart';

class ThemeStyle {
  static ThemeData appTheme() => ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      scaffoldBackgroundColor: kBlackColor,
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: const Color(0xFFF5F5F5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 15,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodySmall: TextStyle(color: kLightColor),
        bodyMedium: TextStyle(color: kLightColor),
        bodyLarge: TextStyle(color: kLightColor),
        headlineLarge: TextStyle(color: kLightColor),
      ).apply(
        bodyColor: kLightColor,
        displayColor: kLightColor,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        circularTrackColor: primaryColor,
      ));
}
