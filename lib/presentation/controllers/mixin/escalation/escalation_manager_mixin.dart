import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/data/models/escalation_model.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/controllers/escalation_controller.dart';
import 'package:esportly/presentation/controllers/mixin/escalation/escalation_market_mixin.dart';

//===MIXIN - GERENCIAMENTO DE ESCALAÇÃO===
mixin EscalationManagerMixin on ChangeNotifier, EscalationMarketMixin implements EscalationBase {
  @override
  bool canManager = false;

  String _category = '';
  @override
  String get category => _category;
  @override
  set category(String v) { _category = v; notifyListeners(); }

  String _formation = '';
  @override
  String get formation => _formation;
  @override
  set formation(String v) { _formation = v; notifyListeners(); }

  int _selectedPlayer = 0;
  @override
  int get selectedPlayer => _selectedPlayer;
  @override
  set selectedPlayer(int v) { _selectedPlayer = v; notifyListeners(); }

  String _selectedOccupation = '';
  @override
  String get selectedOccupation => _selectedOccupation;
  @override
  set selectedOccupation(String v) { _selectedOccupation = v; notifyListeners(); }

  int _selectedPlayerCapitan = 0;
  @override
  int get selectedPlayerCapitan => _selectedPlayerCapitan;
  @override
  set selectedPlayerCapitan(int v) { _selectedPlayerCapitan = v; notifyListeners(); }

  double _managerPatrimony = 100.0;
  @override
  double get managerPatrimony => _managerPatrimony;
  @override
  set managerPatrimony(double v) { _managerPatrimony = v; notifyListeners(); }

  double _managerTeamPrice = 0.0;
  @override
  double get managerTeamPrice => _managerTeamPrice;
  @override
  set managerTeamPrice(double v) { _managerTeamPrice = v; notifyListeners(); }

  double _managerValuation = 0.0;
  @override
  double get managerValuation => _managerValuation;
  @override
  set managerValuation(double v) { _managerValuation = v; notifyListeners(); }

  @override
  List<String> formations = [];

  //DADOS DO EVENTO
  @override
  late EventModel? event;

  final List<Map<String, dynamic>> _myEscalations = [];
  @override
  List<Map<String, dynamic>> get myEscalations => _myEscalations;

  //ESTADOS
  final Map<String, Map<int, UserModel?>> _escalation = {};
  @override
  Map<String, Map<int, UserModel?>> get escalation => _escalation;

  final List<int?> _starters = [];
  @override
  List<int?> get starters => _starters;

  final List<int?> _reserves = [];
  @override
  List<int?> get reserves => _reserves;

  //FUNÇÃO PARA SELECIONAR EVENTO E ATUALIZAR DADOS REFERNTES AO EVENTO
  void setEvent(id) async {
    isLoading = true;
    try {
      event = events.firstWhere((event) => event.id == id);
      setPlayersMarket(await userService.usersSuggestionFetch());
      setFilteredPlayersMarket([]);
      category = events.firstWhere((e) => e.id == id).gameConfig!.category;
      formations = escalationService.getFormations(category);
    } catch (e) {
      hasError = true;
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
    isLoading = false;
  }

  //FUNÇÃO QUE RESGATAR DADOS DE ESCALAÇÃO DO USUARIO NO EVENTO SELECIONADO
  void setUserInfo() {
    isLoading = true;
    try {
      EscalationModel userEscalation = escalationService.generateEscalation(category);
      formation = userEscalation.formation!;
      final startersList = userEscalation.starters ?? escalationService.setEscalation(category, 'starters');
      final reservesList = userEscalation.reserves ?? escalationService.setEscalation(category, 'reserves');
      _starters.clear();
      _starters.addAll(startersList);
      _reserves.clear();
      _reserves.addAll(reservesList);
      managerPatrimony = user.manager!.economies!.firstWhere((e) => e.eventId == event!.id).patrimony!;
      managerTeamPrice = user.manager!.economies!.firstWhere((e) => e.eventId == event!.id).price!;
      managerValuation = user.manager!.economies!.firstWhere((e) => e.eventId == event!.id).valuation!;
    } catch (e) {
      hasError = true;
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
    isLoading = false;
  }
}
