import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:esportly/core/storage/app_storage.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/theme/app_colors.dart';

class ThemeController extends ChangeNotifier {
  //GETTER - INSTANCIA DE CONTROLLER DE EVENTOS
  static ThemeController get instance => sl<ThemeController>();

  //ESTADO - TEMA DO APP
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  set themeMode(ThemeMode v) { _themeMode = v; notifyListeners(); }

  String _mainModality = "Football";
  String get mainModality => _mainModality;
  set mainModality(String v) { _mainModality = v; notifyListeners(); }

  String modalityColor = "green_300";

  Color _primaryColor = AppColors.green_300;
  Color get primaryColor => _primaryColor;
  set primaryColor(Color color) { _primaryColor = color; notifyListeners(); }

  void init() {
    //SELECIONAR TEMA SALVO
    themeMode = setTheme(AppStorage.read<String>('themeMode'));
    mainModality = alterPrimaryColor(AppStorage.read<String>('mainModality') ?? "Football");
  }

  //FUNÇÃO DE DEFINIÇÃO DO TEMA
  ThemeMode setTheme(value) {
    if (value == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  //FUNÇÃO PARA DEFINIR MODALIDADE PRINCIPAL DO USUARIO
  void setModality(String modality) {
    AppStorage.write('mainModality', modality);
    mainModality = alterPrimaryColor(modality);
  }

  //FUNÇÃO DE ALTERAÇÃO DE TEMA
  void alterTheme() {
    themeMode = themeMode != ThemeMode.dark
      ? ThemeMode.dark
      : ThemeMode.light;
    AppStorage.write("themeMode", themeMode.name);
  }

  //FUNÇÃO PARA ALTERAR COR PRINCIPAL DO APP
  String alterPrimaryColor(String modality) {
    //DEFINIR COR PRINCIPAL
    switch (modality) {
      case 'Volleyball':
        AppStorage.write('modalityColor',"yellow_500");
        primaryColor = AppColors.yellow_500;
        break;
      case 'Basketball':
        AppStorage.write('modalityColor',"orange_300");
        primaryColor = AppColors.orange_300;
        break;
      default:
        AppStorage.write('modalityColor',"green_300");
        primaryColor = AppColors.green_300;
        break;
    }
    return modality;
  }
}
