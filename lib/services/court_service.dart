import 'package:futzada/theme/app_icones.dart';

class CourtService {
  //FUNÇÕES DE ESTAMPA DO CAMPO
  String fieldType(String? category){
    switch (category) {
      case 'Futebol':
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.futebol_sm;
      case 'Fut7':
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.fut7_sm;
      case 'Futsal':
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.futsal_sm;
      default:
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.futebol_sm;
    }
  }
}