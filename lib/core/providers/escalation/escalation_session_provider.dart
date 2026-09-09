import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/economy_model.dart';
import 'package:esportly/data/models/escalation_model.dart';
import 'package:esportly/data/services/escalation_service.dart';
import 'package:esportly/core/providers/escalation/escalation_market_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';

//ESTADO - SESSÃO DE ESCALAÇÃO
class EscalationSessionState {
  final bool ready;
  final bool error;
  final bool loading;
  final UserModel? user;
  final EventModel? event;
  final List<EventModel> events;
  final String category;
  final List<String> formations;
  final String formation;
  final bool canManager;
  final double economy;
  final double price;
  final double valuation;
  final Map<String, dynamic> escalation;

  const EscalationSessionState({
    this.ready = false,
    this.error = false,
    this.loading = false,
    this.user,
    this.event,
    this.events = const [],
    this.category = 'Futebol',
    this.formations = const [],
    this.formation = '4-3-3',
    this.canManager = false,
    this.economy = 100.0,
    this.price = 0.0,
    this.valuation = 0.0,
    this.escalation = const {},
  });

  EscalationSessionState copyWith({
    bool? ready,
    bool? error,
    bool? loading,
    EventModel? event,
    List<EventModel>? events,
    UserModel? user,
    String? category,
    List<String>? formations,
    String? formation,
    bool? canManager,
    double? economy,
    double? price,
    double? valuation,
  }) => EscalationSessionState(
    ready: ready ?? this.ready,
    error: error ?? this.error,
    loading: loading ?? this.loading,
    event: event ?? this.event,
    events: events ?? this.events,
    user: user ?? this.user,
    category: category ?? this.category,
    formations: formations ?? this.formations,
    formation: formation ?? this.formation,
    canManager: canManager ?? this.canManager,
    economy: economy ?? this.economy,
    price: price ?? this.price,
    valuation: valuation ?? this.valuation,
  );
}

//NOTIFICADOR - SESSÃO DE ESCALAÇÃO
class EscalationSessionNotifier extends Notifier<EscalationSessionState> {
  EscalationService get _escalationService => EscalationService();

  @override
  EscalationSessionState build() => const EscalationSessionState();

  /* 
  _________________________________________

  REQUISIÇÕES
  _________________________________________
  */

  //FUNÇÃO DE SALVAMENTO DA ESCALAÇÃO NA API
  Future<void> saveEscalation() async {
    final team = ref.read(escalationTeamProvider);
    state = state.copyWith(loading: true);
    try {
      await _escalationService.saveEscalation({
        'escalation': {
          'event_id':   state.event?.id,
          'manager_id': state.user?.manager?.id,
          'formation':  state.formation,
          'starters':   team.starters,
          'reserves':   team.reserves,
          'capitan':    team.capitan,
        },
        'economy': {
          'event_id':   state.event?.id,
          'manager_id': state.user?.manager?.id,
          'price':      state.price,
          'economy':  state.economy,
        }
      });
    } catch (e) {
      print(e);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
    state = state.copyWith(loading: false);
  }

  /* 
  _________________________________________

  SETTERS
  _________________________________________
  */

  //FUNÇÃO DE INICIALIZAÇÃO DE PROVIDER DE ESCALÇÃO
  void init(List<EventModel>? events, UserModel user) {
    //ENCERRAR PROVIDER NA MEMORIA
    dispose();
    try {
      state = state.copyWith(loading: true, user: user);
      //VERIFICAR SE USUARIO ESTA HABILITADO COMO TECNICO
      if(user.manager == null) {
        state = state.copyWith(
          error: true,
          loading: false,
          canManager: false,
        );
        return;
      }
      //VERIFICAR SE USUARIO ESTA REGISTRADO EM ALGUM EVENTO
      if((events?.isEmpty ?? false)){
        state = state.copyWith(
          loading: false, 
          error: true
        );
        return;
      }
      state = state.copyWith(events: events!);
    } catch (e) {
      state = state.copyWith(error: true);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
    state = state.copyWith(loading: false);
  }

  //FUNÇÃO DE RESET COMPLETO — limpa estado próprio e invalida providers dependentes
  void dispose() {
    ref.invalidate(escalationTeamProvider);
    ref.invalidate(escalationMarketProvider);
    state = const EscalationSessionState();
  }

  //FUNÇÃO DE DEFINIÇÃO DE EVENTO ATUAL
  Future<void> setEvent(EventModel event) async {
    try {
      final category = event.gameConfig!.category;
      final formations = _escalationService.formations[category];
      final formation  = _escalationService.formations[category]!.first;
      state = state.copyWith(
        event: event, 
        category: category, 
        formations: formations, 
        formation: formation
      );
      await setUserInfo();
      await setParticipants();
    } catch (e) {
      state = state.copyWith(error: true);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
  }

  //FUNÇÃO DE DEFINIÇÃO DE INFORMAÇÕES DE TECNICO DO USUARIO PARA O EVENTO SELECIONADO
  Future<void> setUserInfo() async {
    try {
      //USUARIO
      final UserModel user = state.user!;
      //ESCALAÇÃO DO USUARIO
      final EscalationModel? escalation = (user.manager?.escalations ?? [])
        .where((e) => e.eventId == state.event!.id)
        .toList()
        .firstOrNull;
      //ECONOMIA DO USUARIO
      final EconomyModel? economy = (user.manager?.economies ?? [])
        .where((e) => e.eventId == state.event!.id)
        .toList()
        .firstOrNull; 
      //DEFINIR TITULARES E RESERVAS
      ref.read(escalationTeamProvider.notifier).setLineup(
        escalation?.starters ?? [], 
        escalation?.reserves ?? [], 
        state.category
      );
      //ATUALIZAR ESTADO
      state = state.copyWith(
        formation: escalation?.formation ?? state.formation,
        economy: economy?.patrimony ?? state.economy,
        price: economy?.price ?? state.price,
        valuation: economy?.valuation ?? state.valuation,
      );
    } catch (e) {
      state = state.copyWith(error: true);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
  }

  //FUNÇÃO DE BUSCA DE PARTICIPANTES DO EVENTO SELECIONADO
  Future<void> setParticipants() async {
    final local = state.event!.participants;
    final List<UserModel> players;
    if (local != null && local.isNotEmpty) {
      players = local.where((p) => p.player != null).toList();
    } else {
      final fetched = await _escalationService.participantsFetch(state.event!.id!);
      players = fetched.whereType<UserModel>().where((p) => p.player != null).toList();
    }
    ref.read(escalationMarketProvider.notifier).setPlayersMarket(players);
  }

  //FUNÇÃO DE DEFINIÇÃO DE FORMAÇÃO
  void setFormation(String formation) {
    state = state.copyWith(formation: formation);
  }
}

//PROVIDER - SESSÃO DE ESCALAÇÃO
final escalationSessionProvider = NotifierProvider<EscalationSessionNotifier, EscalationSessionState>(EscalationSessionNotifier.new);
