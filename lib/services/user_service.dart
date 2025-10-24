import 'package:futzada/models/user_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/repository/user_repository.dart';
import 'package:futzada/services/event_service.dart';
import 'package:futzada/services/participant_service.dart';


class UserService {
  //INSTANCIAR SERVIÇO DE EVENTOS
  EventService eventService = EventService();
  //INSTANCIAR SERVIÇO DE PARTICIPANTS
  ParticipantService participantService = ParticipantService();
  //INSTANCIAR SERVIÇO DE EVENTOS
  UserRepository userRepository = UserRepository();
  
  //FUNÇÃO PARA BUSCAR EVENTOS DO USUARIO LOGADO
  Future<List<EventModel>> fetchEventsUser() async {
    //BUSCAR EVENTOS DO USUARIO
    var events = await eventService.getEvents();
    return events;
  }

  //FUNÇÃO PARA GERAÇÃO DE USUARIOS
  List<UserModel> generateUsers(){
    return List.generate(50, (i){
      return userRepository.generateUser(i, true);
    });
  }

  //FUNÇÃO DE BUSCA DE DADOS DO USUARIO
  Future<ParticipantModel> fetchProfileUser(int id) async{
    var participant = await participantService.generateParticipant(id);
    return participant;
  }
}