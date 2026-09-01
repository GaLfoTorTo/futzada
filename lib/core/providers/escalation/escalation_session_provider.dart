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
  final UserModel? user;
  final EventModel? event;
  final List<EventModel> events;
  final String category;
  final List<String> formations;
  final String formation;
  final bool isReady;
  final bool isLoading;
  final bool hasError;
  final bool canManager;
  final double patrimony;
  final double price;
  final double valuation;
  final List<Map<String, dynamic>> escalations;

  const EscalationSessionState({
    this.user,
    this.event,
    this.events = const [],
    this.category = 'Futebol',
    this.formations = const [],
    this.formation = '4-3-3',
    this.isReady = false,
    this.isLoading = false,
    this.hasError = false,
    this.canManager = false,
    this.patrimony = 100.0,
    this.price = 0.0,
    this.valuation = 0.0,
    this.escalations = const [],
  });

  EscalationSessionState copyWith({
    EventModel? event,
    List<EventModel>? events,
    UserModel? user,
    String? category,
    List<String>? formations,
    String? formation,
    bool? isReady,
    bool? isLoading,
    bool? hasError,
    bool? canManager,
    double? patrimony,
    double? price,
    double? valuation,
    List<Map<String, dynamic>>? escalations,
  }) => EscalationSessionState(
    event: event ?? this.event,
    events: events ?? this.events,
    user: user ?? this.user,
    category: category ?? this.category,
    formations: formations ?? this.formations,
    formation: formation ?? this.formation,
    isReady: isReady ?? this.isReady,
    isLoading: isLoading ?? this.isLoading,
    hasError: hasError ?? this.hasError,
    canManager: canManager ?? this.canManager,
    patrimony: patrimony ?? this.patrimony,
    price: price ?? this.price,
    valuation: valuation ?? this.valuation,
    escalations: escalations ?? this.escalations,
  );
}

//NOTIFICADOR - SESSÃO DE ESCALAÇÃO
class EscalationSessionNotifier extends Notifier<EscalationSessionState> {
  EscalationService get _escalationService => EscalationService();

  @override
  EscalationSessionState build() => const EscalationSessionState();

  //FUNÇÃO DE INICIALIZAÇÃO DE PROVIDER DE ESCALÇÃO
  Future<void> init(List<EventModel> events, UserModel user) async {
    state = state.copyWith(isLoading: true, events: events, user: user);
    try {
      if (events.isNotEmpty) {
        await setEvent(events.first.id);
        state = state.copyWith(isReady: true);
      } else {
        state = state.copyWith(hasError: true);
      }
    } catch (e) {
      state = state.copyWith(hasError: true);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
    state = state.copyWith(isLoading: false);
  }

  //FUNÇÃO DE DEFINIÇÃO DE EVENTO ATUAL
  Future<void> setEvent(dynamic id) async {
    state = state.copyWith(isLoading: true);
    try {
      final event = state.events.firstWhere((e) => e.id == id);
      final category = event.gameConfig!.category;
      final formations = _escalationService.getFormations(category);
      final formation = formations[0];
      state = state.copyWith(
        event: event, 
        category: category, 
        formations: formations, 
        formation: formation
      );
      //BUSCAR PARTICIPANTES DO EVENTO SELECIONADO
      getParticipants();
      //INFORMAÇÕES DO USUARIO
      setUserInfo();
    } catch (e) {
      state = state.copyWith(hasError: true);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
    state = state.copyWith(isLoading: false);
  }

  //FUNÇÃO DE BUSCA DE PARTICIPANTES DO EVENTO SELECIONADO
  Future<void> getParticipants() async {
    final players = state.event!.participants?.where((p) => p.player != null).toList();
    ref.read(escalationMarketProvider.notifier).setPlayersMarket(players ?? []);
  }

  //FUNÇÃO DE DEFINIÇÃO DE INFORMAÇÕES DE TECNICO DO USUARIO PARA O EVENTO SELECIONADO
  void setUserInfo() {
    state = state.copyWith(isLoading: true);
    final UserModel user = state.user!;
    try {
      final EscalationModel? escalation = (user.manager?.escalations ?? [])
        .where((e) => e.eventId == state.event!.id)
        .toList()
        .firstOrNull; 
      final EconomyModel? economy = (user.manager?.economies ?? [])
        .where((e) => e.eventId == state.event!.id)
        .toList()
        .firstOrNull; 
      final formation = escalation?.formation!;
      final startersList = escalation?.starters ?? _escalationService.setEscalation(state.category, 'starters');
      final reservesList = _normalizeReserves(escalation?.reserves, state.category);
      ref.read(escalationTeamProvider.notifier).setLineup(startersList, reservesList);
      state = state.copyWith(
        formation: formation,
        patrimony: economy?.patrimony ?? 100.0,
        price: economy?.price ?? 0.0,
        valuation: economy?.valuation ?? 0.0,
      );
    } catch (e, stacktrace) {
      print("erro user: ${e} \n ${stacktrace}");
      state = state.copyWith(hasError: true);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
    state = state.copyWith(isLoading: false);
  }

  //NORMALIZA O TAMANHO DA LISTA DE RESERVAS AO MÁXIMO CORRETO DA CATEGORIA
  //Evita que dados salvos com contagens antigas (ex: 7) sobrescrevam o teto atual
  List<int?> _normalizeReserves(List<int?>? saved, String category) {
    final canonical = _escalationService.setEscalation(category, 'reserves');
    final target = canonical.length;
    if (saved == null) return canonical;
    if (saved.length == target) return saved;
    if (saved.length > target) return saved.take(target).toList();
    return [...saved, ...List<int?>.filled(target - saved.length, null)];
  }

  //FUNÇÃO DE DEFINIÇÃO DE FORMAÇÃO
  void setFormation(String formation) {
    state = state.copyWith(formation: formation);
  }

  //FUNÇÃO DE DEFINIÇÃO DE JOGADOR NA ESCALAÇÃO
  void setPlayerEscalation(dynamic id) {
    final market = ref.read(escalationMarketProvider);
    final idx = market.playersMarket.indexWhere((p) => p.id == id);
    final user = market.playersMarket[idx];

    try {
      final isEscaled = ref.read(escalationTeamProvider.notifier).findPlayerEscalation(id);
      ref.read(escalationTeamProvider.notifier).setPlayerPosition(user);
      final playerPrice = user.player?.ratings
          ?.firstWhere((r) => r.eventId == state.event?.id, orElse: () => user.player!.ratings!.first)
          .price ?? 0.0;
      //CALCULAR PREÇO DO TIME
      calcTeamPrice(playerPrice, isEscaled ? 'remove' : 'add');
    } catch (e) {
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
  }

  //FUNÇÃO DE CALCULO DE PREÇO DA EQUIPE
  void calcTeamPrice(double playerPrice, String action) {
    final rounded = double.parse(playerPrice.toStringAsFixed(2));
    if (action == 'add') {
      state = state.copyWith(
        price: double.parse((state.price + rounded).toStringAsFixed(2)),
        patrimony: double.parse((state.patrimony - rounded).toStringAsFixed(2)),
      );
    } else {
      state = state.copyWith(
        price: double.parse((state.price - rounded).toStringAsFixed(2)),
        patrimony: double.parse((state.patrimony + rounded).toStringAsFixed(2)),
      );
    }
  }
}

//PROVIDER - SESSÃO DE ESCALAÇÃO
final escalationSessionProvider = NotifierProvider<EscalationSessionNotifier, EscalationSessionState>(EscalationSessionNotifier.new);
