import 'package:flutter/material.dart';
import 'package:futzada/controllers/rank_controller.dart';
import 'package:futzada/services/timer_service.dart';
import 'package:get/get.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/services/manager_service.dart';
import 'package:futzada/services/home_service.dart';
import 'package:futzada/services/user_service.dart';
import 'package:futzada/controllers/chat_controller.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/explorer_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/controllers/notification_controller.dart';
import 'package:futzada/controllers/auth_controller.dart';

class HomeController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static HomeController get instance => Get.find();
  //CONTROLLER DE BARRA NAVEGAÇÃO
  final authController = AuthController.instance;

  //INSTANCIAR SERVIÇO DE USUARIO
  UserService userService = UserService();
  //INSTANCIAR SERVIÇO DE TECNICO  (MANAGER)
  ManagerService managerService = ManagerService();
  //INSTANCIAR SERVIÇO DE HOME
  HomeService homeService = HomeService();
  //LISTA DE EVENTOS DO USUARIO
  List<EventModel> userEvents = [];

  //LISTA DE ADS
  List<Map<String, dynamic>> ads = [];
  //LISTA DE RANKINGS - PERTO DE VOCE
  List<Map<String, dynamic>> eventsToYou = [];
  //LISTA DE EVENTOS - POPULARES
  List<Map<String, dynamic>> eventsPopular = [];
  //LISTA DE RANKINGS - TOP RANKING
  List<Map<String, dynamic>> ranking = [];
  //LISTA DE PARTIDAS
  List<Map<String, dynamic>> partidas = [];

  @override
  void onInit() {
    super.onInit();
    //RESGATAR EVENTOS DO USUARIO
    _loadUserEvents();
    //INICIALIZAR SERVIÇO DE CRONOMETRO
    Get.put(TimerService());
  }

  //FUNÇÃO PARA BUSCA INFORMAÇÕES DA HOME PAGE
  Future<dynamic>fetchHome() async{
    //EXECUTAR BUSCA DE DADOS PARA HOME PAGE
    try {
    //EXECUTAR AS BUSCAS DE DADOS SIMULTANEAMENTE
    final results = await Future.wait([
      homeService.fetchCloseEvents(),
      //userService.fecthTopRanking(),
      //userService.fecthPopular(),
      //userService.fecthUltimosJogos(),
    ]);

    //PREENCHER LISTAS COM OS DADOS RESGATADOS
    eventsToYou = results[0] ?? [];
    ranking     = results[1] ?? [];
    eventsPopular = results[2] ?? [];
    partidas    = results[3] ?? [];

    //RETORNAR DADOS RESGATADOS
    return {
      'eventsToYou': eventsToYou,
      'ranking': ranking,
      'eventsPopular': eventsPopular,
      'partidas': partidas,
    };
    } catch (e) {
      print('Erro ao buscar dados da home: $e');
      return {
        'eventsToYou': [],
        'ranking': [],
        'eventsPopular': [],
        'partidas': [],
      };
    }
  }

  void _loadUserEvents() async{
    //BUSCAR EVENTOS QUE O USUARIO ESTA PARTICIPANDO
    List<EventModel> events = await userService.fetchEventsUser();
    userEvents.addAll(events);
    //VERIFICAR SE ALGUM EVENTO FOI ENCONTRADO
    if(events.isNotEmpty){
      //ADICIONAR GLOBALMENT AO GET EVENTOS DO USUARIO
      Get.put(events, tag: 'events', permanent: true);
      //RESGATAR USUARIO LOGADO
      UserModel user = Get.find(tag: 'user');
      //ADICIONAR DADOS DE TECNICO CASO EXISTAM
      user.manager = managerService.generateManager(1);
      //INICIALIZAR CONTROLLER DE EVENTO
      Get.put(EventController());
      //INICIALIZAR CONTROLLER DE EVENTO
      Get.put(EscalationController());
      //INICIALIZAR CONTROLLER DE PARTIDAS
      Get.put(GameController());
      //INICIALIZAR CONTROLLER DE RANKINGS
      Get.put(RankController());
      //INICIALIZAR CONTROLLER DE EXPLORER
      /* Get.put(ExplorerController()); */
      //INICIALIZAR CONTROLLER CHAT PAGE
      Get.put(ChatController());
      //INICIALIZAR CONTROLLER DE NOTIFICAÇÕES
      Get.put(NotificationController());
    }
  }
}