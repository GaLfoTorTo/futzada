import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_size.dart';

class AppStyle {
  AppStyle._();

  //TEXT LIGHT THEME
  static TextTheme lightTextTheme = TextTheme(
    //HEADLINES
    headlineLarge: const TextStyle().copyWith(fontSize: AppSize.fontXxl, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    headlineMedium: const TextStyle().copyWith(fontSize: AppSize.fontXl, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    headlineSmall: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    //TITLES
    titleLarge: const TextStyle().copyWith(fontSize: AppSize.fontXl, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    titleMedium: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.bold, color: AppColors.dark_300),
    titleSmall: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.bold, color: AppColors.dark_300),
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
    titleLarge: const TextStyle().copyWith(fontSize: AppSize.fontXl, fontWeight: FontWeight.bold, color: AppColors.white),
    titleMedium: const TextStyle().copyWith(fontSize: AppSize.fontLg, fontWeight: FontWeight.bold, color: AppColors.white),
    titleSmall: const TextStyle().copyWith(fontSize: AppSize.fontMd, fontWeight: FontWeight.bold, color: AppColors.white),
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

  //TEXT BUTTON THEME
  static final textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.green_300,
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
  static final elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: AppColors.green_300,
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
  
  //BUTTON LIGHT THEME
  static OutlinedButtonThemeData lightOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.blue_500,
      backgroundColor: AppColors.white,
      disabledForegroundColor: AppColors.blue_500,
      disabledBackgroundColor: AppColors.gray_300,
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
  

  //BUTTON DARK THEME
  static OutlinedButtonThemeData darkOutlineButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.dark_500,
      disabledForegroundColor: AppColors.white,
      disabledBackgroundColor: AppColors.dark_300,
      side: const BorderSide(color: AppColors.white),
      padding: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      textStyle: const TextStyle(
        fontSize: AppSize.fontMd,
        color: AppColors.white,
        fontWeight: FontWeight.normal
      ),
    )
  );

  //ICONE LIGHT THEME
  static const IconThemeData iconLightTheme = IconThemeData(
    color: AppColors.blue_500,
    size: AppSize.iconMd,
  );

  //ICONE LIGHT THEME
  static const IconThemeData iconDarkTheme = IconThemeData(
    color: AppColors.white,
    size: AppSize.iconMd,
  );

  //APP BAR THEME
  static const appBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.green_300,//Colors.transparent default
    surfaceTintColor: AppColors.green_300,//Colors.transparent default
    iconTheme: IconThemeData(color: AppColors.blue_500, size: 24),
    actionsIconTheme: IconThemeData(color: AppColors.blue_500, size: 24),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: AppColors.blue_500)
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
  static CheckboxThemeData checkBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    checkColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.white;
      }else{
        return AppColors.gray_500;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }else{
        return Colors.transparent;
      }
    }),
  );

  //INPUT LIGHT THEME
  static InputDecorationTheme lightInputTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.white,
    errorMaxLines: 3,
    prefixIconColor: AppColors.gray_500,
    suffixIconColor: AppColors.gray_500,
    errorStyle: const TextStyle(
      fontStyle: FontStyle.normal
    ),
    floatingLabelStyle: const TextStyle(
      color: AppColors.dark_500, 
      fontSize: AppSize.fontXl, 
      fontWeight: FontWeight.bold,
    ),
    labelStyle: const TextStyle(
      color: AppColors.gray_500,
      fontSize: AppSize.fontMd,
    ),
    hintStyle: const TextStyle(
      color: AppColors.gray_300,
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
    fillColor: AppColors.dark_500,
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
      color: AppColors.gray_500,
      fontSize: AppSize.fontMd,
    ),
    hintStyle: const TextStyle(
      color: AppColors.gray_300,
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
  static final DatePickerThemeData lightDatePickerTheme = DatePickerThemeData(
    headerBackgroundColor: AppColors.green_300,
    headerForegroundColor: AppColors.white,
    backgroundColor: AppColors.white,
    rangePickerBackgroundColor: AppColors.white,
    rangePickerHeaderBackgroundColor: AppColors.green_300,
    rangePickerHeaderForegroundColor: AppColors.white,
    rangeSelectionBackgroundColor: AppColors.green_300,
    dayBackgroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.white;
    }),
    dayForegroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.white;
      }
      return AppColors.dark_500;
    }),
    todayBackgroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.white;
    }),
    todayForegroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.white;
      }
      return AppColors.dark_500;
    }),
    yearBackgroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.white;
    }),
    yearForegroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.white;
      }
      return AppColors.dark_500;
    }),
    dayStyle: const TextStyle(
      color: AppColors.green_300
    ),
    yearStyle: const TextStyle(
      color: AppColors.green_300
    ),
    confirmButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.green_300),
    ),
    cancelButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.green_300),
    )
  );
  
  ////DATE PICKER LIGHT THEME
  static final DatePickerThemeData darkDatePickerTheme = DatePickerThemeData(
    headerBackgroundColor: AppColors.green_300,
    headerForegroundColor: AppColors.dark_500,
    backgroundColor: AppColors.dark_500,
    rangePickerBackgroundColor: AppColors.dark_500,
    rangePickerHeaderBackgroundColor: AppColors.green_300,
    rangePickerHeaderForegroundColor: AppColors.white,
    rangeSelectionBackgroundColor: AppColors.green_300,
    dayBackgroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.dark_500;
    }),
    dayForegroundColor: const WidgetStatePropertyAll(AppColors.white),
    todayBackgroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.dark_500;
    }),
    todayForegroundColor: const WidgetStatePropertyAll(AppColors.white),
    yearBackgroundColor: WidgetStateProperty.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.dark_500;
    }),
    yearForegroundColor: const WidgetStatePropertyAll(AppColors.white),
    dayStyle: const TextStyle(
      color: AppColors.green_300
    ),
    yearStyle: const TextStyle(
      color: AppColors.green_300
    ),
    confirmButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.white),
    ),
    cancelButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.white),
    )
  );

  //TIME PICKER LIGHT THEME
  static final TimePickerThemeData lightTimePickerTheme = TimePickerThemeData(
    backgroundColor: AppColors.white,
    dialBackgroundColor: AppColors.light,
    dialHandColor: AppColors.green_300,
    dialTextColor: AppColors.dark_500,
    dayPeriodColor: WidgetStateColor.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.red_300;
      }
      return AppColors.white;
    }),
    dayPeriodTextColor:WidgetStateColor.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.white;
      }
      return AppColors.dark_500;
    }),
    hourMinuteColor: WidgetStateColor.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.green_100.withOpacity(0.5);
    }),
    hourMinuteTextStyle: const TextStyle(
      fontSize: AppSize.fontXxl,
      fontWeight: FontWeight.bold
    ),
    hourMinuteTextColor: AppColors.white,
    entryModeIconColor: AppColors.dark_500,
    confirmButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.green_300),
    ),
    cancelButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.green_300),
    )
  );
  //TIME PICKER DARK THEME
  static final TimePickerThemeData darkTimePickerTheme = TimePickerThemeData(
    backgroundColor: AppColors.dark_500,
    dialBackgroundColor: AppColors.dark_300,
    dialHandColor: AppColors.green_300,
    dialTextColor: AppColors.white,
    dayPeriodColor: WidgetStateColor.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.red_300;
      }
      return AppColors.dark_500;
    }),
    dayPeriodTextColor: AppColors.white,
    hourMinuteColor: WidgetStateColor.resolveWith((state){
      if(state.contains(WidgetState.selected)){
        return AppColors.green_300;
      }
      return AppColors.green_100.withOpacity(0.5);
    }),
    hourMinuteTextStyle: const TextStyle(
      fontSize: AppSize.fontXxl,
      fontWeight: FontWeight.bold
    ),
    hourMinuteTextColor: AppColors.white,
    entryModeIconColor: AppColors.white,
    confirmButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.green_300),
    ),
    cancelButtonStyle: const ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
      foregroundColor: WidgetStatePropertyAll(AppColors.green_300),
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
  
  //NAVIGATION BAR LIGHT THEME
  static NavigationBarThemeData lightNavigationTheme = NavigationBarThemeData(
    elevation: 8,
    backgroundColor: AppColors.white,
    indicatorColor: Colors.transparent,
    shadowColor: AppColors.dark_500.withOpacity(0.5),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.blue_500,
            size: AppSize.iconXl,
          );
        }
        return const IconThemeData(
          color: AppColors.gray_300,
          size: AppSize.iconLg,
        );
      },
    ),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );
  
  //NAVIGATION BAR LIGHT THEME
  static NavigationBarThemeData darkNavigationTheme = NavigationBarThemeData(
    elevation: 0,
    backgroundColor: AppColors.white,
    indicatorColor: Colors.transparent,
    shadowColor: AppColors.dark_500.withOpacity(0.5),
    iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.white,
            size: AppSize.iconXl,
          );
        }
        return const IconThemeData(
          color: AppColors.gray_300,
          size: AppSize.iconLg,
        );
      },
    ),
    labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
  );

  //BOTTON NAVIGATION BAR LIGHT THEME
  static BottomNavigationBarThemeData lightBottomNavigationTheme = const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: AppColors.white,
    enableFeedback: true,
    selectedIconTheme: IconThemeData(
      color: AppColors.blue_500,
      size: AppSize.iconXl
    ),
    unselectedIconTheme: IconThemeData(
      color: AppColors.gray_300,
      size: AppSize.iconLg
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
  );
  
  //BOTTON NAVIGATION BAR DARK THEME
  static BottomNavigationBarThemeData darkBottomNavigationTheme = const BottomNavigationBarThemeData(
    elevation: 0,
    backgroundColor: AppColors.dark_500,
    enableFeedback: true,
    selectedIconTheme: IconThemeData(
      color: AppColors.white,
      size: AppSize.iconXl
    ),
    unselectedIconTheme: IconThemeData(
      color: AppColors.gray_300,
      size: AppSize.iconLg
    ),
    showSelectedLabels: false,
    showUnselectedLabels: false,
    type: BottomNavigationBarType.shifting,
  );
  
  //TAB BAR LIGHT THEME
  static TabBarTheme lightTabBarTheme = const TabBarTheme(
    indicator: BoxDecoration(),
  );
  
  //TAB BAR DARK THEME
  static TabBarTheme darkTabBarTheme = const TabBarTheme(
    indicator: BoxDecoration(),
  );

  /* //DATE PICKER LIGHT THEME
  static DatePickerTheme lightDatePickerTheme = DatePickerTheme(
    data: DatePickerThemeData(
      backgroundColor: AppColors.white,
      cancelButtonStyle: ButtonStyle(
        enableFeedback: true,
      ),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(AppColors.green_300)
      )
    ),      
  );
  
  //DATE PICKER DARK THEME
  static DatePickerTheme darkDatePickerTheme = DatePickerTheme(
    data: DatePickerThemeData(
      backgroundColor: AppColors.white,
      cancelButtonStyle: ButtonStyle(
        enableFeedback: true,
      ),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(AppColors.green_300)
      )
    ),    
  ); */
}