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
    bottomNavigationBarTheme: AppStyle.lightBottomNavigationTheme,
    navigationBarTheme: AppStyle.lightNavigationTheme,
    inputDecorationTheme: AppStyle.lightInputTheme,
    datePickerTheme: AppStyle.lightDatePickerTheme,
    timePickerTheme: AppStyle.lightTimePickerTheme,
    checkboxTheme: AppStyle.checkBoxTheme,
    textButtonTheme: AppStyle.textButtonTheme,
    elevatedButtonTheme: AppStyle.elevatedButtonTheme,
    outlinedButtonTheme: AppStyle.lightOutlineButtonTheme,
    iconTheme: AppStyle.iconLightTheme,
    bottomSheetTheme: AppStyle.lightBottomSheetTheme,
    drawerTheme: AppStyle.lightDrawerTheme,
    tabBarTheme: AppStyle.lightTabBarTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: AppColors.green_300,
    scaffoldBackgroundColor: AppColors.dark_500,
    textTheme: AppStyle.darkTextTheme,
    appBarTheme: AppStyle.appBarTheme,
    bottomNavigationBarTheme: AppStyle.darkBottomNavigationTheme,
    navigationBarTheme: AppStyle.darkNavigationTheme,
    inputDecorationTheme: AppStyle.darkInputTheme,
    datePickerTheme: AppStyle.darkDatePickerTheme,
    timePickerTheme: AppStyle.darkTimePickerTheme,
    checkboxTheme: AppStyle.checkBoxTheme,
    textButtonTheme: AppStyle.textButtonTheme,
    elevatedButtonTheme: AppStyle.elevatedButtonTheme,
    outlinedButtonTheme: AppStyle.darkOutlineButtonTheme,
    iconTheme: AppStyle.iconDarkTheme,
    bottomSheetTheme: AppStyle.darkBottomSheetTheme,
    drawerTheme: AppStyle.darkDrawerTheme,
    tabBarTheme: AppStyle.darkTabBarTheme,
    /* datePickerTheme: AppStyle.darkDatePickerTheme, */
  );
}