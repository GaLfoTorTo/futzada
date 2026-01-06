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
    cardTheme: AppStyle.lightCardTheme,
    appBarTheme: AppStyle.appBarTheme,
    bottomNavigationBarTheme: AppStyle.lightBottomNavigationTheme,
    navigationBarTheme: AppStyle.lightNavigationTheme,
    inputDecorationTheme: AppStyle.lightInputTheme,
    datePickerTheme: AppStyle.lightDatePickerTheme,
    timePickerTheme: AppStyle.lightTimePickerTheme,
    checkboxTheme: AppStyle.checkBoxTheme,
    textButtonTheme: AppStyle.textButtonTheme,
    elevatedButtonTheme: AppStyle.lightElevatedButtonTheme,
    outlinedButtonTheme: AppStyle.lightOutlineButtonTheme,
    iconTheme: AppStyle.iconLightTheme,
    dialogTheme: AppStyle.lightDialogTheme,
    bottomSheetTheme: AppStyle.lightBottomSheetTheme,
    drawerTheme: AppStyle.lightDrawerTheme,
    tabBarTheme: AppStyle.lightTabBarTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Nunito',
    brightness: Brightness.dark,
    primaryColor: AppColors.green_300,
    scaffoldBackgroundColor: AppColors.dark_700,
    textTheme: AppStyle.darkTextTheme,
    cardTheme: AppStyle.darkCardTheme,
    appBarTheme: AppStyle.appBarTheme,
    bottomNavigationBarTheme: AppStyle.darkBottomNavigationTheme,
    navigationBarTheme: AppStyle.darkNavigationTheme,
    inputDecorationTheme: AppStyle.darkInputTheme,
    datePickerTheme: AppStyle.darkDatePickerTheme,
    timePickerTheme: AppStyle.darkTimePickerTheme,
    checkboxTheme: AppStyle.checkBoxTheme,
    textButtonTheme: AppStyle.textButtonTheme,
    elevatedButtonTheme: AppStyle.darkElevatedButtonTheme,
    outlinedButtonTheme: AppStyle.darkOutlineButtonTheme,
    iconTheme: AppStyle.iconDarkTheme,
    dialogTheme: AppStyle.darkDialogTheme,
    bottomSheetTheme: AppStyle.darkBottomSheetTheme,
    drawerTheme: AppStyle.darkDrawerTheme,
    tabBarTheme: AppStyle.darkTabBarTheme,
    /* datePickerTheme: AppStyle.darkDatePickerTheme, */
  );
}