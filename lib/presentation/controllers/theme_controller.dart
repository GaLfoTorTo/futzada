import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_themes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  //GETTER - INSTANCIA DE CONTROLLER DE EVENTOS
  static ThemeController get instance => Get.find();
  //INSTANCIAR STORAGE
  final storage = GetStorage();
  //ESTADO - TEMA DO APP
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  RxString mainModality = "Football".obs;
  String modalityColor = "green_300";

  final Rx<Color> _primaryColor = AppColors.green_300.obs;
  //GETTER E SETTER - PRIMARY COLOR
  Color get primaryColor => _primaryColor.value;
  set primaryColor(Color color) => _primaryColor.value = color;

  @override
  void onReady() {
    //SELECIONAR TEMA SALVO
    themeMode.value = setTheme(storage.read('themeMode'));
    mainModality.value = alterPrimaryColor(storage.read('mainModality') ?? "Football");
    //ALTERAR TEMA SELECIONADO
    Get.changeThemeMode(themeMode.value);
    super.onInit();
  }
  //FUNÇÃO DE DEFINIÇÃO DO TEMA
  ThemeMode setTheme(value) {
    if(value == 'dark'){
      return ThemeMode.dark;
    }else{
      return ThemeMode.light;
    }
  }

  //FUNÇÃO PARA DEFINIR MODALIDADE PRINCIPAL DO USUARIO
  void setModality(String modality) {
    storage.write('mainModality', modality);
    mainModality.value = alterPrimaryColor(modality);
  }

  //FUNÇÃO DE ALTERAÇÃO DE TEMA
  void alterTheme(){
    //ALTERNAR TEMA 
    themeMode.value = themeMode.value != ThemeMode.dark
      ? ThemeMode.dark
      : ThemeMode.light;
    //SALVAR TEMA SELECIONADO      
    storage.write("themeMode", themeMode.value.name);
    //ALTERAR TEMA
    Get.changeThemeMode(themeMode.value);
  }

  //FUNÇÃO PARA ALTERAR COR PRINCIPAL DO APP
  String alterPrimaryColor(String modality){
    //DEFINIR COR PRINCIPAL
    switch (modality) {
      case 'Volleyball':
        storage.write('modalityColor', "yellow_500");
        primaryColor = AppColors.yellow_500;
        break;
      case 'Basketball':
        storage.write('modalityColor', "orange_300");
        primaryColor = AppColors.orange_300;
        break;
      default:
        storage.write('modalityColor', "green_300");
        primaryColor = AppColors.green_300;
        break;
    }
    //ALTERAR TEMA
    Get.changeTheme(
      themeMode.value == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme
    );
    return modality;
  }
}