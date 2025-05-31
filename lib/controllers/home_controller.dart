import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/services/manager_service.dart';
import 'package:futzada/services/home_service.dart';
import 'package:futzada/services/user_service.dart';
import 'package:futzada/controllers/auth_controller.dart';

class HomeController extends GetxController{
  //CONTROLLER DE BARRA NAVEGAÇÃO
  final authController = AuthController.instance;
  //DEFINIR CONTROLLER UNICO NO GETX
  static HomeController get instance => Get.find();
  //INSTANCIAR SERVIÇO DE USUARIO
  UserService userService = UserService();
  //INSTANCIAR SERVIÇO DE TECNICO  (MANAGER)
  ManagerService managerService = ManagerService();
  //INSTANCIAR SERVIÇO DE HOME
  HomeService homeService = HomeService();

  //LISTA DE OPTIONS PARA O CARD PERTO DE VOCE
  List<Map<String, dynamic>> events = [];
  //LISTA DE OPTIONS PARA O CARD TOP RANKING
  List<Map<String, dynamic>> ranking = [];
  //LISTA DE OPTIONS PARA O CARD POPULAR
  List<Map<String, dynamic>> popular = [];
  //LISTA DE OPTIONS PARA O CARD POPULAR
  List<Map<String, dynamic>> partidas = [];

  @override
  void onInit() {
    super.onInit();
    //RESGATAR EVENTOS DO USUARIO
    _loadUserEvents();
  }

  //FUNÇÃO PARA SIMULAR BUSCA DE TODAS AS INFORMAÇÕES EXIBIDAS NA HOME PAGE
  Future<dynamic>fetchHome() async{
    //EXECUTAR BUSCA DE DADOS PARA HOME PAGE
    await Future.wait([
      homeService.fetchCloseEvents(),
      //userService.fecthTopRanking(),
      //userService.fecthPopular(),
      //userService.fecthUltimosJogos()
    ]);
    //RETORNAR DADOS BUSCADOS
    return [
      events,
      ranking,
      popular,
      partidas
    ];
  }

  void _loadUserEvents() async{
    //BUSCAR EVENTOS QUE O USUARIO ESTA PARTICIPANDO
    List<EventModel> events = await userService.fetchEventsUser();
    //VERIFICAR SE ALGUM EVENTO FOI ENCONTRADO
    if(events.isNotEmpty){
      //ADICIONAR GLOBALMENT AO GET EVENTOS DO USUARIO
      Get.put(events, tag: 'events', permanent: true);
      //RESGATAR USUARIO LOGADO
      UserModel user = Get.find(tag: 'user');
      //ADICIONAR DADOS DE TECNICO CASO EXISTAM
      user.manager = managerService.generateManager(1);
    }
  }
}