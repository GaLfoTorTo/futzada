//===EVENT BASE===
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/services/user_service.dart';
import 'package:get/get.dart';

abstract class EventBase {
  //GETTER - SERVIÇO DE PARTIDAS
  UserService get profileService;
  //GETTER - USUARIO
  ParticipantModel get participant;
  UserModel get user;
  List<EventModel> get events;
  //SETTER - USUARIO
  set participant(ParticipantModel participant);
  set user(UserModel user);
  set events(List<EventModel> events);
}

class ProfileController extends GetxController  implements EventBase{
  final int id;
  ProfileController({required this.id});

  //GETTER DE SERVIÇOS
  @override
  UserService profileService = UserService();
  //DEFINIR PARTICIPANT
  @override
  late ParticipantModel participant;
  //DEFINIR USUARIO
  @override
  late UserModel user;
  //DEFINIR EVENTOS DO USUARIO- OBRIGATÓRIO
  @override
  late List<EventModel> events;

  @override
  void onInit() {
    //INICIALIZAR CONTROLLER
    super.onInit();
    //RESGATAR DADOS DO USUARIO
    getProfileUser(this.id);
  }

  @override
  void onClose() {
    //ENCERRAR CONTROLLER
    super.onClose();
  }

  //FUNÇÃO DE BUSCA DE DADOS DO USUARIO
  void getProfileUser(int id) async {
    participant = await profileService.fetchProfileUser(id);
    user = participant.user;
  }
}