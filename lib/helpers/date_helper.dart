import 'package:futzada/models/event_model.dart';
import 'package:intl/intl.dart';

class DateHelper {
  //FUNÇÃO PARA RESGATAR DATA DA PELADA
  static String getEventDate(EventModel event){
    return event.daysWeek!.replaceAll("[", '').replaceAll("]", '');
  }

  //FUNÇÃO PARA RESGATAR DATA RELATIVA
  static String getDateLabel(DateTime date) {
    //RESGATAR DATA DE HOJE COMPLETA
    final now = DateTime.now();
    //RESGATAR DATA DE HOJE (DD/MM/YYYY)
    final today = DateTime(now.year, now.month, now.day);
    //DATA ALVO (DD/MM/YYYY)
    final targetDate = DateTime(date.year, date.month, date.day);
    //RESGATAR DIFERENÇA ENTRE AS DATA
    final difference = today.difference(targetDate).inDays;
    //VERIFICAR DIFERENÇA ENTRE DATA
    switch (difference) {
      case 0:
        return "Hoje";
      case 1:
        return "Ontem";
      case -1:
        return "Amanhã";
      default:
        return DateFormat('dd/MM/yyyy').format(date);
    }
  } 
}