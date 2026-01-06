import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  //GETTER - INSTANCIA DE CONTROLLER DE EVENTOS
  static ThemeController get instance => Get.find();
  //INSTANCIAR STORAGE
  final storage = GetStorage();
  //ESTADO - TEMA DO APP
  late Rx<ThemeMode> themeMode;

  @override
  void onInit() {
    //RESGATAR TEMA SALVO SE EXISTIR
    final themeSaved = storage.read('themeMode');
    //SELECIONAR TEMA SALVO
    themeMode = setTheme(themeSaved).obs;
    //ALTERAR TEMA SELECIONADO
    Get.changeThemeMode(themeMode.value);
    super.onInit();
  }
  //FUNÇÃO DE DEFINIÇÃO DO TEMA
  ThemeMode setTheme(value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  //FUNÇÃO DE ALTERAÇÃO DE TEMA
  void alterTheme() {
    //ALTERNAR TEMA 
    themeMode.value = themeMode.value != ThemeMode.dark
      ? ThemeMode.dark
      : ThemeMode.light;
    //SALVAR TEMA SELECIONADO      
    storage.write("themMode", themeMode.value.name);
    //ALTERAR TEMA
    Get.changeThemeMode(themeMode.value);
  }

}