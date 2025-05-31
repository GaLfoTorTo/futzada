import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/repository/user_repository.dart';
import 'package:futzada/services/event_service.dart';


class UserService {
  //INSTANCIAR SERVIÇO DE EVENTOS
  EventService eventService = EventService();
  
  //FUNÇÃO PARA BUSCAR EVENTOS DO USUARIO LOGADO
  Future<List<EventModel>> fetchEventsUser() async {
    //BUSCAR EVENTOS DO USUARIO
    var events = await eventService.getEvents();
    return events;
  }
}