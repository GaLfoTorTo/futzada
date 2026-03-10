import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/manager_service.dart';
import 'package:futzada/data/services/user_service.dart';
import 'package:futzada/data/services/escalation_service.dart';
import 'package:futzada/data/services/market_service.dart';
import 'package:futzada/data/services/participant_service.dart';
import 'package:futzada/presentation/controllers/mixin/escalation/escalation_manager_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/escalation/escalation_market_mixin.dart';
import 'package:futzada/presentation/controllers/mixin/escalation/escalation_team_mixin.dart';

//===DEPENDENCIAS BASE===
abstract class EscalationBase {
  //GETTER - SERVIÇOS
  UserService get userService;
  EscalationService get escalationService;
  ParticipantService get participantService;
  MarketService get marketService;
  ManagerService get managerService;
  
  //GETTER - USUÁRIO E EVENTOS
  UserModel get user;
  List<EventModel> get events;

  //ESTADO - CARREGAMENTO DE DADOS
  RxBool get isReady;
  RxBool get isLoading;
  RxBool get hasError;
  
  //GETTER - ESTADOS
  bool get canManager;
  RxString get category;
  RxString get formation;
  RxInt get selectedPlayer;
  RxString get selectedOccupation;
  RxInt get selectedPlayerCapitan;
  RxDouble get managerPatrimony;
  RxDouble get managerTeamPrice;
  RxDouble get managerValuation;
  List<String> get formations;
  
  //GETTER - FILTROS
  RxMap<String, dynamic> get filtrosMarket;
  Map<String, List<Map<String, dynamic>>> get filterOptions;
  Map<String, List<Map<String, dynamic>>> get filterPlayerOptions;
  
  //GETTER - DADOS DO EVENTO
  EventModel? get event;
  RxList<Map<String, dynamic>> get myEscalations;
  RxList<UserModel> get playersMarket;
  RxList<UserModel> get filteredPlayersMarket;
  RxMap<String, RxMap<int, UserModel?>> get escalation;
  List<int?> get starters;
  List<int?> get reserves;
  
  //CONTROLADOR DE PESQUISA
  TextEditingController get pesquisaController;
}

class EscalationController extends GetxController 
  with EscalationManagerMixin, EscalationMarketMixin, EscalationTeamMixin {
  
  //GETTER DE CONTROLLERS
  static EscalationController get instance => Get.find();
  
  //GETTER DE SERVIÇOS
  @override
  final UserService userService = UserService();
  @override
  final EscalationService escalationService = EscalationService();
  @override
  final ParticipantService participantService = ParticipantService();
  @override
  final MarketService marketService = MarketService();
  @override
  final ManagerService managerService = ManagerService();

  //ESTADOS - USUARIO E EVENTOS
  @override
  UserModel user = Get.find(tag: 'user');
  @override
  late List<EventModel> events = [];

  //ESTADOS - CARREGAMENTO DE DADOS
  @override
  RxBool isReady = false.obs;
  @override
  RxBool isLoading = false.obs;
  @override
  RxBool hasError = false.obs;
  
  //CONTROLADOR DE PESQUISA
  @override
  final TextEditingController pesquisaController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    //RESGATAR EVENTOS DO USUARIO
    events = Get.find(tag: 'events');
    try {
      if(events.isNotEmpty){
        //DEFINIR DADOS DO EVENTO
        setEvent(events.first.id);
        //CARREGAR DADOS DE TECNICO
        setUserInfo();
        isReady.value = true;
      }else{
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
    }
    isLoading.value = false;
  }
}