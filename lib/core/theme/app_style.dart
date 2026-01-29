import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_size.dart';
import 'package:get_storage/get_storage.dart';

class AppStyle {
  const AppStyle();

  //RESGATAR COR PRINCIPAL
  static Color get primaryColor => AppColors.colors[GetStorage().read('modalityColor')] ?? AppColors.green_300;

  //TEXT LIGHT THEME
  static TextTheme lightTextTheme = TextTheme(
    //HEADLINES
    headlineLarge: const TextStyle().copyWith(fontSize: AppSize.fontXxl, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    headlineMedium: const TextStyle().copyWith(fontSize: AppSize.fontXl, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    headlineSmall: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    //TITLES
    titleLarge: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    titleMedium: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    titleSmall: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    //BODY
    bodyLarge: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    bodyMedium: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    bodySmall: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    //LABELS
    labelLarge: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    labelMedium: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    labelSmall: const TextStyle().copyWith(fontSize: AppSize.fontXs, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    //DISPLAY
    displayLarge: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    displayMedium: const TextStyle().copyWith(fontSize: AppSize.fontXs, fontWeight: FontWeight.normal, color: AppColors.dark_300),
    displaySmall: const TextStyle().copyWith(fontSize: AppSize.fontXxs, fontWeight: FontWeight.normal, color: AppColors.dark_300),
  );

  //TEXT DARK THEME
  static TextTheme darkTextTheme = TextTheme(
    //HEADLINES
    headlineLarge: const TextStyle().copyWith(fontSize: AppSize.fontXxl, fontWeight: FontWeight.bold, color: AppColors.white),
    headlineMedium: const TextStyle().copyWith(fontSize: AppSize.fontXl, fontWeight: FontWeight.bold, color: AppColors.white),
    headlineSmall: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.bold, color: AppColors.white),
    //TITLES
    titleLarge: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.bold, color: AppColors.white),
    titleMedium: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.bold, color: AppColors.white),
    titleSmall: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.bold, color: AppColors.white),
    //LABELS
    labelLarge: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.normal, color: AppColors.white),
    labelMedium: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.normal, color: AppColors.white),
    labelSmall: const TextStyle().copyWith(fontSize: AppSize.fontXs, fontWeight: FontWeight.normal, color: AppColors.white),
    //BODY
    bodyLarge: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.normal, color: AppColors.white),
    bodyMedium: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.normal, color: AppColors.white),
    bodySmall: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.normal, color: AppColors.white),
    //DISPLAY
    displayLarge: const TextStyle().copyWith(fontSize: AppSize.fontSm, fontWeight: FontWeight.normal, color: AppColors.white),
    displayMedium: const TextStyle().copyWith(fontSize: AppSize.fontXs, fontWeight: FontWeight.normal, color: AppColors.white),
    displaySmall: const TextStyle().copyWith(fontSize: AppSize.fontXxs, fontWeight: FontWeight.normal, color: AppColors.white),
  );

    //ICONE LIGHT THEME
  static IconThemeData iconLightTheme = const IconThemeData(
    color: AppColors.blue_500,
    size: AppSize.iconMd,
  );

  //ICONE LIGHT THEME
  static IconThemeData iconDarkTheme = const IconThemeData(
    color: AppColors.white,
    size: AppSize.iconMd,
  );

  //TEXT BUTTON THEME
  static TextButtonThemeData get textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: AppColors.blue_500,
      disabledForegroundColor: AppColors.green_100,
      disabledBackgroundColor: AppColors.blue_100,
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(
        fontSize: AppSize.fontMd,
        color: AppColors.blue_500,
        fontWeight: FontWeight.normal
      ),
    )
  );

  //ELEVATED BUTTON LIGHT THEME
  static ElevatedButtonThemeData lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.grey_300,
      disabledBackgroundColor: AppColors.grey_300,
      disabledForegroundColor: AppColors.grey_500,
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(
        fontSize: AppSize.fontMd,
        color: AppColors.dark_500,
        fontWeight: FontWeight.normal
      ),
    )
  );
  
  //ELEVATED BUTTON DARK THEME
  static ElevatedButtonThemeData darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.dark_300,
      foregroundColor: AppColors.dark_700,
      disabledBackgroundColor: AppColors.dark_700,
      disabledForegroundColor: AppColors.dark_700,
      padding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(
        fontSize: AppSize.fontMd,
        color: AppColors.white,
        fontWeight: FontWeight.normal
      ),
    )
  );
  
  //BUTTON OUTLINE LIGHT THEME
  static OutlinedButtonThemeData lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.blue_500,
      backgroundColor: AppColors.white,
      disabledForegroundColor: AppColors.blue_500,
      disabledBackgroundColor: AppColors.grey_300,
      side: const BorderSide(color: AppColors.blue_500),
      padding: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(
        fontSize: AppSize.fontMd,
        color: AppColors.blue_500,
        fontWeight: FontWeight.normal
      ),
    )
  );

  //BUTTON OUTLINE DARK THEME
  static OutlinedButtonThemeData darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.dark_500,
      disabledForegroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.dark_300,
      side: const BorderSide(color: AppColors.white),
      padding: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      textStyle: const TextStyle(
        fontSize: AppSize.fontMd,
        color: AppColors.white,
        fontWeight: FontWeight.normal
      ),
    )
  );

  //CARD LIGHT THEME
  static CardThemeData lightCardTheme = const CardThemeData(
    color: AppColors.white,
    elevation: 2,
  );
  
  //CARD DARK THEME
  static CardThemeData darkCardTheme = const CardThemeData(
    color: AppColors.dark_300,
    elevation: 2,
  );


  //DIALOG LIGHT THEME
  static DialogThemeData lightDialogTheme = DialogThemeData(
    backgroundColor: AppColors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
  );

  //DIALOG DARK THEME
  static DialogThemeData darkDialogTheme = DialogThemeData(
    backgroundColor: AppColors.dark_500,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
  );

  //BOTTOM SHEET LIGHT THEME
  static BottomSheetThemeData lightBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: AppColors.white,
    modalBackgroundColor: AppColors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
  );

  //BOTTOM SHEET DARK THEME
  static BottomSheetThemeData darkBottomSheetTheme = BottomSheetThemeData(
    showDragHandle: true,
    backgroundColor: AppColors.white,
    modalBackgroundColor: AppColors.white,
    constraints: const BoxConstraints(minWidth: double.infinity),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
  );

  //CHECKBOX LIGHT/DARK THEME 
  static CheckboxThemeData get checkBoxTheme => CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    checkColor: const WidgetStatePropertyAll(AppColors.white),
    fillColor: WidgetStatePropertyAll(primaryColor),
  );

  //INPUT LIGHT THEME
  static InputDecorationTheme lightInputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    errorMaxLines: 3,
    prefixIconColor: AppColors.grey_500,
    suffixIconColor: AppColors.grey_500,
    errorStyle: const TextStyle(
      fontStyle: FontStyle.normal
    ),
    floatingLabelStyle: const TextStyle(
      color: AppColors.dark_500, 
      fontSize: AppSize.fontXl, 
      fontWeight: FontWeight.bold,
    ),
    labelStyle: const TextStyle(
      color: AppColors.grey_500,
      fontSize: AppSize.fontMd,
    ),
    hintStyle: const TextStyle(
      color: AppColors.grey_300,
      fontSize: AppSize.fontMd,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.green_300),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    contentPadding: const EdgeInsets.all(15),
  );

  //INPUT DARK THEME
  static InputDecorationTheme darkInputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.dark_300,
    errorMaxLines: 3,
    prefixIconColor: AppColors.white,
    suffixIconColor: AppColors.white,
    errorStyle: const TextStyle(
      fontStyle: FontStyle.normal
    ),
    floatingLabelStyle: const TextStyle(
      color: AppColors.white, 
      fontSize: AppSize.fontXl, 
      fontWeight: FontWeight.bold
    ),
    labelStyle: const TextStyle(
      color: AppColors.white,
      fontSize: AppSize.fontMd,
    ),
    hintStyle: const TextStyle(
      color: AppColors.white,
      fontSize: AppSize.fontMd,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    disabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.green_300),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  );

  //DROPDOWN MENU LIGHT THEME
  static final InputDecoration lightDropdownMenuTheme =  InputDecoration(
    filled: true,
    fillColor: AppColors.white,
    errorMaxLines: 3,
    errorStyle: const TextStyle(
      fontStyle: FontStyle.normal
    ),
    floatingLabelStyle: const TextStyle(
      color: AppColors.dark_500, 
      fontSize: AppSize.fontXl, 
      fontWeight: FontWeight.bold
    ),
    labelStyle: const TextStyle(
      color: AppColors.grey_500,
      fontSize: AppSize.fontMd,
    ),
    hintStyle: const TextStyle(
      color: AppColors.grey_300,
      fontSize: AppSize.fontMd,
      fontWeight: FontWeight.normal
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.green_300),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    contentPadding: const EdgeInsets.all(15),
  );

  //DROPDOWN MENU DARK THEME
  static final InputDecoration darkDropdownMenuTheme = InputDecoration(
    filled: true,
    fillColor: AppColors.dark_500,
    errorMaxLines: 3,
    errorStyle: const TextStyle(
      fontStyle: FontStyle.normal
    ),
    floatingLabelStyle: const TextStyle(
      color: AppColors.white, 
      fontSize: AppSize.fontXl, 
      fontWeight: FontWeight.bold
    ),
    labelStyle: const TextStyle(
      color: AppColors.white,
      fontSize: AppSize.fontMd,
    ),
    hintStyle: const TextStyle(
      color: AppColors.white,
      fontSize: AppSize.fontMd,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.green_300),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.red_300),
    ),
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
  );

  //DATE PICKER LIGHT THEME
  static DatePickerThemeData get lightDatePickerTheme => DatePickerThemeData(
    headerBackgroundColor: primaryColor,
    headerForegroundColor: AppColors.white,
    backgroundColor: AppColors.white,
    rangePickerBackgroundColor: AppColors.white,
    rangePickerHeaderBackgroundColor: primaryColor,
    rangePickerHeaderForegroundColor: AppColors.white,
    rangeSelectionBackgroundColor: primaryColor,
    dayBackgroundColor: const WidgetStatePropertyAll(AppColors.white),
    dayForegroundColor: const WidgetStatePropertyAll(AppColors.dark_500),
    todayBackgroundColor: const WidgetStatePropertyAll(AppColors.white),
    todayForegroundColor: const WidgetStatePropertyAll(AppColors.dark_500),
    yearBackgroundColor: const WidgetStatePropertyAll(AppColors.white),
    yearForegroundColor: const WidgetStatePropertyAll(AppColors.dark_500),
    dayStyle: TextStyle(
      color: primaryColor
    ),
    yearStyle: TextStyle(
      color: primaryColor
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    )
  );
  
  ////DATE PICKER LIGHT THEME
  static DatePickerThemeData get darkDatePickerTheme => DatePickerThemeData(
    headerBackgroundColor: primaryColor,
    headerForegroundColor: AppColors.dark_500,
    backgroundColor: AppColors.dark_500,
    rangePickerBackgroundColor: AppColors.dark_500,
    rangePickerHeaderBackgroundColor: primaryColor,
    rangePickerHeaderForegroundColor: AppColors.white,
    rangeSelectionBackgroundColor: primaryColor,
    dayForegroundColor: const WidgetStatePropertyAll(AppColors.white),
    todayBackgroundColor: const WidgetStatePropertyAll(AppColors.dark_500),
    todayForegroundColor: const WidgetStatePropertyAll(AppColors.white),
    yearBackgroundColor: const WidgetStatePropertyAll(AppColors.dark_500),
    yearForegroundColor: const WidgetStatePropertyAll(AppColors.white),
    dayStyle: TextStyle(
      color: primaryColor
    ),
    yearStyle: TextStyle(
      color: primaryColor
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    )
  );

  //TIME PICKER LIGHT THEME
  static TimePickerThemeData get lightTimePickerTheme => TimePickerThemeData(
    backgroundColor: AppColors.white,
    dialBackgroundColor: AppColors.light,
    dialHandColor: primaryColor,
    dialTextColor: AppColors.dark_500,
    dayPeriodColor: AppColors.white,
    dayPeriodTextColor:AppColors.dark_500,
    hourMinuteColor: AppColors.green_100.withAlpha(50),
    hourMinuteTextStyle: const TextStyle(
      fontSize: AppSize.fontXxl,
      fontWeight: FontWeight.bold
    ),
    hourMinuteTextColor: AppColors.white,
    entryModeIconColor: AppColors.dark_500,
    confirmButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    )
  );

  //TIME PICKER DARK THEME
  static TimePickerThemeData get darkTimePickerTheme => TimePickerThemeData(
    backgroundColor: AppColors.dark_500,
    dialBackgroundColor: AppColors.dark_300,
    dialHandColor: primaryColor,
    dialTextColor: AppColors.white,
    dayPeriodColor: AppColors.dark_500,
    dayPeriodTextColor: AppColors.white,
    hourMinuteColor: AppColors.green_100.withAlpha(50),
    hourMinuteTextStyle: const TextStyle(
      fontSize: AppSize.fontXxl,
      fontWeight: FontWeight.bold
    ),
    hourMinuteTextColor: AppColors.white,
    entryModeIconColor: AppColors.white,
    confirmButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    ),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(primaryColor),
    )
  );

  //DRAWER LIGHT THEME
  static DrawerThemeData lightDrawerTheme = const DrawerThemeData(
    backgroundColor: AppColors.white,
    surfaceTintColor: AppColors.dark_500
  );
  
  //DRAWER DARK THEME
  static DrawerThemeData darkDrawerTheme = const DrawerThemeData(
    backgroundColor: AppColors.dark_500,
    surfaceTintColor: AppColors.white
  );
  
  //APP BAR THEME
  static AppBarTheme get appBarTheme => AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: primaryColor,
    surfaceTintColor: primaryColor,
    iconTheme: const IconThemeData(color: AppColors.blue_500, size: 24),
    actionsIconTheme: const IconThemeData(color: AppColors.blue_500, size: 24),
    titleTextStyle: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: AppColors.blue_500)
  );

  //NAVIGATION BAR LIGHT THEME
  static NavigationBarThemeData lightNavigationTheme = NavigationBarThemeData(
    elevation: 2,
    backgroundColor: AppColors.white,
    indicatorColor: Colors.transparent,
    iconTheme: WidgetStateProperty.all(const IconThemeData(color: AppColors.grey_300, size: 25)),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );
  
  //NAVIGATION BAR LIGHT THEME
  static NavigationBarThemeData darkNavigationTheme = NavigationBarThemeData(
    elevation: 2,
    backgroundColor: AppColors.dark_500,
    indicatorColor: Colors.transparent,
    iconTheme: WidgetStateProperty.all(const IconThemeData(color: AppColors.white, size: 25)),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );

  //BOTTOM NAVIGATION BAR LIGHT THEME
  static BottomNavigationBarThemeData lightBottomNavigationTheme = const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: AppColors.white,
    enableFeedback: true,
    selectedIconTheme: IconThemeData(
      color: AppColors.blue_500,
      size: AppSize.iconXl
    ),
    unselectedIconTheme: IconThemeData(
      color: AppColors.grey_300,
      size: AppSize.iconLg
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
  );
  
  //BOTTOM NAVIGATION BAR DARK THEME
  static BottomNavigationBarThemeData darkBottomNavigationTheme = const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: AppColors.dark_500,
    enableFeedback: true,
    selectedIconTheme: IconThemeData(
      color: AppColors.white,
      size: AppSize.iconXl
    ),
    unselectedIconTheme: IconThemeData(
      color: AppColors.grey_300,
      size: AppSize.iconLg
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.shifting,
  );
  
  //TAB BAR LIGHT THEME
  static TabBarThemeData get lightTabBarTheme => TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: primaryColor,
    labelStyle: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelColor: AppColors.grey_500,
    unselectedLabelStyle: const TextStyle(
      color: AppColors.grey_500,
      fontWeight: FontWeight.normal,
    ),
    labelPadding: const EdgeInsets.symmetric(vertical: 5),
  );
  
  //TAB BAR DARK THEME
  static TabBarThemeData get darkTabBarTheme => TabBarThemeData(
    indicatorSize: TabBarIndicatorSize.tab,
    labelColor: primaryColor,
    labelStyle: TextStyle(
      color: primaryColor,
      fontWeight: FontWeight.bold,
    ),
    unselectedLabelColor: AppColors.white,
    unselectedLabelStyle: const TextStyle(
      color: AppColors.white,
      fontWeight: FontWeight.normal,
    ),
    labelPadding: const EdgeInsets.symmetric(vertical: 5),
  );
}