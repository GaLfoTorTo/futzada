import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/di/service_locator.dart';
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
  bool get isReady;
  set isReady(bool v);
  bool get isLoading;
  set isLoading(bool v);
  bool get hasError;
  set hasError(bool v);

  //GETTER - ESTADOS
  bool get canManager;
  String get category;
  set category(String v);
  String get formation;
  set formation(String v);
  int get selectedPlayer;
  set selectedPlayer(int v);
  String get selectedOccupation;
  set selectedOccupation(String v);
  int get selectedPlayerCapitan;
  set selectedPlayerCapitan(int v);
  double get managerPatrimony;
  set managerPatrimony(double v);
  double get managerTeamPrice;
  set managerTeamPrice(double v);
  double get managerValuation;
  set managerValuation(double v);
  List<String> get formations;

  //GETTER - FILTROS
  Map<String, dynamic> get filtrosMarket;
  Map<String, List<Map<String, dynamic>>> get filterOptions;
  Map<String, List<Map<String, dynamic>>> get filterPlayerOptions;

  //GETTER - DADOS DO EVENTO
  EventModel? get event;
  List<Map<String, dynamic>> get myEscalations;
  List<UserModel> get playersMarket;
  List<UserModel> get filteredPlayersMarket;
  Map<String, Map<int, UserModel?>> get escalation;
  List<int?> get starters;
  List<int?> get reserves;

  //CONTROLADOR DE PESQUISA
  TextEditingController get pesquisaController;
}

class EscalationController extends ChangeNotifier
  with EscalationMarketMixin, EscalationManagerMixin, EscalationTeamMixin {

  //GETTER DE CONTROLLERS
  static EscalationController get instance => sl<EscalationController>();

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
  UserModel user = sl<UserModel>();
  @override
  late List<EventModel> events = [];

  //ESTADOS - CARREGAMENTO DE DADOS
  bool _isReady = false;
  @override
  bool get isReady => _isReady;
  @override
  set isReady(bool v) { _isReady = v; notifyListeners(); }

  bool _isLoading = false;
  @override
  bool get isLoading => _isLoading;
  @override
  set isLoading(bool v) { _isLoading = v; notifyListeners(); }

  bool _hasError = false;
  @override
  bool get hasError => _hasError;
  @override
  set hasError(bool v) { _hasError = v; notifyListeners(); }

  //CONTROLADOR DE PESQUISA
  @override
  final TextEditingController pesquisaController = TextEditingController();

  void init() {
    isLoading = true;
    events = sl<List<EventModel>>(instanceName: 'events');
    try {
      if (events.isNotEmpty) {
        setEvent(events.first.id);
        setUserInfo();
        isReady = true;
      } else {
        hasError = true;
      }
    } catch (e) {
      hasError = true;
    }
    isLoading = false;
  }
}
