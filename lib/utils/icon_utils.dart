import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';

class IconUtils {
  //FUNÇÃO PARA RESGATAR ICONE DA CATEGORIA
  static IconData getIconCategory(category){
    switch (category) {
      case "Futebol":
        return AppIcones.foot_futebol_solid;
      case "Fut7":
        return AppIcones.foot_fut7_solid;
      case "Futsal":
        return AppIcones.foot_futsal_solid;
      default:
        return AppIcones.foot_futebol_solid;
    }
  }
}