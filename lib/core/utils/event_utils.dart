import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';

class EventUtils {
  //FUNÇÃO PARA RESGATAR NOME COMPLETO DO USUARIO
  static UserModel? getUserEvent(EventModel event,int userId){
    return event.participants?.firstWhere((u) => u.id == userId);
  }
}