import 'dart:ui';

import 'package:futzada/core/theme/app_colors.dart';

class PlayerHelper {
  //FUNÇÃO PARA AJUSTAR A COR DA BORDAS DAS POSIÇÕES
  static Color setColorPosition(dynamic position){
    //VERIFICAR AREA DO CAMPO
    switch (position) {
      case 'ATA':
        return AppColors.blue_300;
      case 'MEI':
        return AppColors.green_300;
      case 'ZAG':
        return AppColors.red_300;
      case 'LAT':
        return AppColors.orange_300;
      case 'GOL':
        return AppColors.yellow_500;
      case "LEV":
        return AppColors.blue_300;
      case "OPO":
        return AppColors.green_300;
      case "CEN":
        return AppColors.cyan_500;
      case "PON":
        return AppColors.red_300;
      case "LIB":
        return AppColors.purple_500;
      case "ARM":
        return AppColors.orange_500;
      case "ALA":
        return AppColors.green_500;
      case "ALM":
        return AppColors.blue_300;
      case "ALP":
        return AppColors.purple_500;
      case "PIV":
        return AppColors.yellow_500;
      case "CAP":
        return AppColors.yellow_200;
      default:
        return AppColors.white;
    }
  }
}