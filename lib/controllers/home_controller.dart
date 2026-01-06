import 'package:futzada/models/event_model.dart';
import 'package:get/get.dart';
import 'package:futzada/services/manager_service.dart';
import 'package:futzada/services/home_service.dart';
import 'package:futzada/services/user_service.dart';

class HomeController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static HomeController get instance => Get.find();

  //INSTANCIAR SERVIÇO DE USUARIO
  UserService userService = UserService();
  //INSTANCIAR SERVIÇO DE TECNICO  (MANAGER)
  ManagerService managerService = ManagerService();
  //INSTANCIAR SERVIÇO DE HOME
  HomeService homeService = HomeService();

  //ESTADO = CARREGAMENTO DE DADOS
  RxBool isReady = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  //LISTA DE ADS
  List<Map<String, dynamic>> ads = [];
  //LISTA DE EVENTOS - PERTO DE VOCE
  late List<EventModel> toYou = [];
  //LISTA DE EVENTOS - POPULARES
  late List<EventModel> popular = [];
  //LISTA DE EVENTOS - HOJE
  late List<EventModel> today = [];
  //LISTA DE RANKINGS - TOP RANKING
  List<Map<String, dynamic>> ranking = [];
  //LISTA DE PARTIDAS
  List<Map<String, dynamic>> partidas = [];

  @override
  void onInit() {
    super.onInit();
  }

  //FUNÇÃO PARA BUSCA INFORMAÇÕES DA HOME PAGE
  Future<dynamic>fetchHome() async{
    //EXECUTAR BUSCA DE DADOS PARA HOME PAGE
    try {
    //EXECUTAR AS BUSCAS DE DADOS SIMULTANEAMENTE
    final results = await Future.wait([
      homeService.fetchFakeEvent(),
      homeService.fetchFakeEvent(),
      homeService.fetchFakeEvent(),
      //userService.fecthPopular(),
      //userService.fecthUltimosJogos(),
    ]);
    //PREENCHER LISTAS COM OS DADOS RESGATADOS
    toYou = results[0];
    popular = results[1];
    today = results[1];
    ///ranking = results[2];
    //partidas = results[3];
    //ATUALIZAR ESTADO DE CARREGAMENTO
    isLoading.value = false;

    //RETORNAR DADOS RESGATADOS
    return {
      'toYou': toYou,
      'ranking': ranking,
      'popular': popular,
      'partidas': partidas,
    };
    } catch (e) {
      hasError.value = true;
      isLoading.value = false;
      print('Erro ao buscar dados da home: $e');
      return {
        'toYou': [],
        'ranking': [],
        'popular': [],
        'partidas': [],
      };
    }
  }
}