import 'package:get/get.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/api_service.dart';
import 'package:futzada/data/services/news_service.dart';
import 'package:futzada/data/services/avaliation_service.dart';
import 'package:futzada/data/repositories/event_repository.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/mixin/event/event_overview_mixin.dart';
import 'package:futzada/presentation/mixin/event/event_config_mixin.dart';
import 'package:futzada/presentation/mixin/event/event_participants_mixin.dart';
import 'package:futzada/presentation/mixin/event/event_rank_mixin.dart';
import 'package:futzada/presentation/mixin/event/event_register_mixin.dart';
import 'package:futzada/presentation/mixin/event/event_rules_mixin.dart';

//===EVENT BASE===
abstract class EventBase {
  //GETTER - REPOSITORIES
  EventRepository get eventRepository;
  //GETTER - SERVIÇOS
  AvaliationService get avaliationService;
  ApiService get apiService;
  NewsService get newsService;
  //GETTER - USUARIO, EVENTOS, EVENTOS DO USUARIO
  UserModel get user;
  //GETTER - EVENTOS DO USUARIO
  List<EventModel> get events;
  //GETTER - EVENTO
  EventModel get event;
  //SETTER - EVENTO
  set event(EventModel event);
  //GETTER - PARTICIPANTS
  Map<String, List<UserModel>?> get participants;
  //DEFINIR TRAVEL MODEL ATUAL SENDO MANIPULADO
  RxString get travelMode;
}

//===CONTROLLER PRINCIPALS===
class EventController extends GetxController 
  with 
    EventOverviewMixin, 
    EventConfigMixin, 
    EventRegisterMixin, 
    EventRankMixin, 
    EventParticipantsMixin, 
    EventRulesMixin 
  implements EventBase {
  
  //GETTER - INSTANCIA DE CONTROLLER DE EVENTOS
  static EventController get instance => Get.find();

  //DEFINIR REPOSITORIES
  @override
  final EventRepository eventRepository = EventRepository();
  
  //DEFINIR SERVIÇOs
  @override
  final AvaliationService avaliationService = AvaliationService();
  @override
  final ApiService apiService = ApiService();
  @override
  final NewsService newsService = NewsService();
  
  //DEFINIR USUARIO LOGADO - OBRIGATÓRIO
  @override
  final UserModel user = Get.find(tag: 'user');
  
  //DEFINIR EVENTOS DO USUARIO LOGADO - OBRIGATÓRIO
  @override
  final List<EventModel> events = Get.find(tag: 'events');
  
  //DEFINIR EVENTO ATUAL SENDO MANIPULADO - OBRIGATÓRIO
  @override
  late EventModel event;
  
  //DEFINIR DE PARTICIPANTES
  @override
  late Map<String, List<UserModel>?> participants;
  
  //DEFINIR DE PARTICIPANTES
  @override
  late RxString travelMode = 'walking'.obs;

  //FUNÇÃO DE SELEÇÃO DE EVENTO
  void setSelectedEvent(EventModel event) {
    //RESGATAR E DEFINIR EVENTO NOS CONTROLLERS
    this.event = event;
    //ATUALIZAR EVENTO NO CONTROLLER DE PARTIDAS
    GameController.instance.event = event;
    //ATUALIZAR CONFIGURAÇÕES DE PARTIDA NO CONTROLLER DE PARTIDAS
    GameController.instance.currentGameConfig = event.gameConfig;
  }
}