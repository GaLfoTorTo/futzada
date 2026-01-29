import 'package:get/get.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/home_service.dart';
import 'package:futzada/data/services/user_service.dart';

//===HOME BASE===
abstract class HomeBase {
  //SERVICES 
  UserService get userService;
  HomeService get homeService;
  //GETTER - USUARIO, EVENTOS DO USUARIO
  UserModel get user;
  List<EventModel> get events;
  //ESTADO - CARREGAMENTO DE DADOS
  RxBool get isReady;
  RxBool get isLoading;
  RxBool get hasError;
  //ESTADOS - HOME
  List<Map<String, dynamic>> get ads;
  List<EventModel> get toYou;
  List<EventModel> get popular;
  List<EventModel> get today;
  List<UserModel> get suggestionFriends;
  List<Map<String, dynamic>> get ranking;
  List<Map<String, dynamic>> get partidas;
}

class HomeController extends GetxController implements HomeBase {
  //CONTROLLERS
  static HomeController get instance => Get.find();

  //SERVICES
  @override
  UserService userService = UserService();
  @override
  HomeService homeService = HomeService();

  //DEFINIR USUARIO LOGADO - OBRIGATÓRIO
  @override
  final UserModel user = Get.find(tag: 'user');
  
  //DEFINIR EVENTOS DO USUARIO LOGADO - OBRIGATÓRIO
  @override
  late List<EventModel> events;

  //ESTADOS - CARREGAMENTO DE DADOS
  @override
  RxBool isReady = false.obs;
  @override
  RxBool isLoading = false.obs;
  @override
  RxBool hasError = false.obs;

  //ESTADOS - HOME
  @override
  late List<Map<String, dynamic>> ads = [];
  @override
  late List<EventModel> toYou = [];
  @override
  late List<EventModel> popular = [];
  @override
  late List<EventModel> today = [];
  @override
  late List<UserModel> suggestionFriends = [];
  @override
  late List<Map<String, dynamic>> ranking = [];
  @override
  late List<Map<String, dynamic>> partidas = [];

  @override
  void onReady() {
    super.onReady;
    //ESPERAR HOME CONTROLLER INICIALIZAR
    events = Get.find(tag: 'events');
    isReady.value = true;
    fetchHome();
  }

  //FUNÇÃO PARA BUSCA INFORMAÇÕES DA HOME PAGE
  Future<void>fetchHome() async{
    isLoading.value = true;
    //EXECUTAR BUSCA DE DADOS PARA HOME PAGE
    try {
      //PREENCHER LISTAS COM OS DADOS RESGATADOS
      toYou = await homeService.fetchFakeEvent();
      popular = await homeService.fetchFakeEvent();
      today = await homeService.fetchFakeEvent();
      suggestionFriends = await userService.fecthSuggestionFriends();
      ///ranking = results[2];
      //partidas = results[3];
      //ATUALIZAR ESTADO DE CARREGAMENTO
      isLoading.value = false;
    } catch (e, stackTrace) { 
      hasError.value = true;
      isLoading.value = false;
      //LOGS DE ERRO
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
    }
  }
}