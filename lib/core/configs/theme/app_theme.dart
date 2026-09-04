import 'package:flutter/material.dart';
import 'package:yt_music/core/configs/theme/app_colors.dart';

class AppTheme {

  static final lightTheme = ThemeData(
    primaryColor:  AppColors.primary,
    primaryTextTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Color(0xff383838)
      )
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,
    fontFamily: "Pinku",
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.all(30),
        labelStyle: TextStyle(
          color: Color(0xff383838),
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color(0xff707070),
            width: 0.7
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 0.7
          ),
        ),
      ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 3.0, // Adjust the elevation for shadow depth
       shadowColor: Colors.transparent, // Customize shadow color
        backgroundColor: AppColors.primary.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
  
  static final darkTheme = ThemeData(
    primaryColor:  AppColors.primary,
    primaryTextTheme: TextTheme(
      bodyMedium: TextStyle(
        color: Colors.white
      )
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,
    fontFamily: "Pinku",
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.all(30),
        labelStyle: TextStyle(
          color: Color(0xffA7A7A7),
          fontWeight: FontWeight.w500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: Color(0xff707070),
            width: 0.7
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 0.7
          ),
        ),
      ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 3.0, // Adjust the elevation for shadow depth
        shadowColor: Colors.transparent, // Customize shadow color
        backgroundColor: AppColors.primary.withValues(alpha: 0.8),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    ),
  );
}