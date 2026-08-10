import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/providers/navigation_provider.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/services/home_service.dart';
import 'package:futzada/data/services/user_service.dart';
import 'package:futzada/data/services/address_service.dart';

//===HOME BASE===
abstract class HomeBase {
  //SERVICES
  UserService get userService;
  HomeService get homeService;
  AddressService get addressService;
  List<EventModel> get events;
  //ESTADO - CARREGAMENTO DE DADOS
  bool get isReady;
  bool get isLoading;
  bool get hasError;
  //ESTADOS - CARDS EVENT
  List<Map<String, dynamic>> get ads;
  List<EventModel> get toYou;
  List<EventModel> get nearby;
  List<EventModel> get popular;
  List<EventModel> get live;
  List<EventModel> get today;
  //ESTADOS - USERS
  List<UserModel> get suggestionFriends;
  List<Map<String, dynamic>> get ranking;
  List<Map<String, dynamic>> get partidas;
}

class HomeController extends ChangeNotifier implements HomeBase {
  //CONTROLLERS
  static HomeController get instance => sl<HomeController>();

  //SERVICES
  @override
  UserService userService = UserService();
  @override
  HomeService homeService = HomeService();
  @override
  AddressService addressService = AddressService();

  //DEFINIR EVENTOS DO USUARIO LOGADO - OBRIGATÓRIO
  @override
  late List<EventModel> events;

  //ESTADOS - CARREGAMENTO DE DADOS
  bool _isReady = false;
  @override
  bool get isReady => _isReady;
  set isReady(bool v) { _isReady = v; notifyListeners(); }

  bool _isLoading = false;
  @override
  bool get isLoading => _isLoading;
  set isLoading(bool v) { _isLoading = v; notifyListeners(); }

  bool _hasError = false;
  @override
  bool get hasError => _hasError;
  set hasError(bool v) { _hasError = v; notifyListeners(); }

  //ESTADOS - HOME
  @override
  final List<Map<String, dynamic>> ads = [];
  @override
  final List<EventModel> toYou = [];
  @override
  final List<EventModel> nearby = [];
  @override
  final List<EventModel> popular = [];
  @override
  final List<EventModel> live = [];
  @override
  final List<EventModel> today = [];
  @override
  final List<UserModel> suggestionFriends = [];
  @override
  final List<Map<String, dynamic>> ranking = [];
  @override
  final List<Map<String, dynamic>> partidas = [];

  void init() {
    //BUSCAR EVENTOS DO USUARIO
    events = sl<List<EventModel>>(instanceName: 'events');
    isReady = true;
    fetchHome();
  }

  //FUNÇÃO PARA BUSCA INFORMAÇÕES DA HOME PAGE
  Future<void> fetchHome() async {
    isLoading = true;
    //EXECUTAR BUSCA DE DADOS PARA HOME PAGE
    try {
      //PREENCHER LISTAS COM OS DADOS RESGATADOS
      final resp = await homeService.fetchHome();
      //SEPARA DADOS
      handleRequest(resp);
      //ATUALIZAR ESTADO DE CARREGAMENTO
      isLoading = false;
      sl<ProviderContainer>().read(navReadyProvider.notifier).state = true;
    } catch (e, stackTrace) {
      hasError = true;
      isLoading = false;
      //LOGS DE ERRO
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
    }
  }

  //FUNÇÃO PARA SEPARAR DADOS RESGATADOS DA API
  void handleRequest(resp) {
    //LIMPAR LISTAS ANTES DE PREENCHER
    ads.clear();
    toYou.clear();
    popular.clear();
    today.clear();
    suggestionFriends.clear();
    ranking.clear();
    partidas.clear();

    //PREENCHER LISTAS COM OS DADOS RESGATADOS
    ads.addAll(resp['ads']                   as List<Map<String, dynamic>>? ?? []);
    toYou.addAll(resp['toYou']               as List<EventModel>? ?? []);
    nearby.addAll(resp['nearby']             as List<EventModel>? ?? []);
    popular.addAll(resp['popular']           as List<EventModel>? ?? []);
    today.addAll(resp['today']               as List<EventModel>? ?? []);
    ranking.addAll(resp['ranking']           as List<Map<String, dynamic>>? ?? []);
    partidas.addAll(resp['partidas']         as List<Map<String, dynamic>>? ?? []);
    suggestionFriends.addAll(resp['friends'] as List<UserModel>? ?? []);
    notifyListeners();
  }
}
