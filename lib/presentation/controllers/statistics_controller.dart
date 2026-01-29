import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/manager_service.dart';
import 'package:futzada/data/services/escalation_service.dart';
import 'package:futzada/data/services/market_service.dart';
import 'package:futzada/data/services/participant_service.dart';

//===DEPENDENCIAS BASE===
abstract class StatisticsBase {
  //GETTER - SERVIÇOS
  EscalationService get escalationService;
  ParticipantService get participantService;
  MarketService get marketService;
  ManagerService get managerService;
  
  //GETTER - USUÁRIO E EVENTOS
  UserModel get user;
  List<EventModel> get userEvents;
  
  //GETTER - EVENTO SELECIONADO
  EventModel? get event;
  
  //CONTROLADOR DE PESQUISA
  TextEditingController get pesquisaController;
}

class StatisticsController extends GetxController implements StatisticsBase {
  
  //GETTER DE CONTROLLERS
  static StatisticsController get instance => Get.find();
  
  //GETTER DE SERVIÇOS
  @override
  final EscalationService escalationService = EscalationService();
  @override
  final ParticipantService participantService = ParticipantService();
  @override
  final MarketService marketService = MarketService();
  @override
  final ManagerService managerService = ManagerService();
  //ESTADOS
  @override
  UserModel user = Get.find(tag: 'user');
  @override
  List<EventModel> userEvents = Get.isRegistered<List<EventModel>>(tag: 'events') 
    ? Get.find<List<EventModel>>(tag: 'events') 
    : [];
  //DADOS DO EVENTO
  @override
  late EventModel? event;
  
  //CONTROLADOR DE PESQUISA
  @override
  final TextEditingController pesquisaController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    event = userEvents.first;
  }

  //FUNÇÃO PARA SELECIONAR EVENTO E ATUALIZAR DADOS REFERNTES AO EVENTO
  void setEvent(id) {
    //ATUALIZAR EVENTO SELECIONADO
    event = userEvents.firstWhere((event) => event.id == id);
  }
}