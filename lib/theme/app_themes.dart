import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_style.dart';

class AppTheme{
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.light,
    primaryColor: AppColors.green_300,
    scaffoldBackgroundColor: AppColors.light,
    textTheme: AppStyle.lightTextTheme,
    appBarTheme: AppStyle.appBarTheme,
    inputDecorationTheme: AppStyle.lightInputTheme,
    checkboxTheme: AppStyle.checkBoxTheme,
    textButtonTheme: AppStyle.textButtonTheme,
    elevatedButtonTheme: AppStyle.elevatedButtonTheme,
    outlinedButtonTheme: AppStyle.lightOutlineButtonTheme,
    bottomSheetTheme: AppStyle.lightBottomSheetTheme,
    drawerTheme: AppStyle.lightDrawerTheme,
    bottomNavigationBarTheme: AppStyle.lightBottomNavigationTheme,
    tabBarTheme: AppStyle.lightTabBarTheme,
    /* datePickerTheme: AppStyle.lightDatePickerTheme, */
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: AppColors.green_300,
    scaffoldBackgroundColor: AppColors.dark_500,
    textTheme: AppStyle.darkTextTheme,
    appBarTheme: AppStyle.appBarTheme,
    inputDecorationTheme: AppStyle.darkInputTheme,
    checkboxTheme: AppStyle.checkBoxTheme,
    textButtonTheme: AppStyle.textButtonTheme,
    elevatedButtonTheme: AppStyle.elevatedButtonTheme,
    outlinedButtonTheme: AppStyle.darkOutlineButtonTheme,
    bottomSheetTheme: AppStyle.darkBottomSheetTheme,
    drawerTheme: AppStyle.darkDrawerTheme,
    bottomNavigationBarTheme: AppStyle.darkBottomNavigationTheme,
    tabBarTheme: AppStyle.darkTabBarTheme,
    /* datePickerTheme: AppStyle.darkDatePickerTheme, */
  );
}