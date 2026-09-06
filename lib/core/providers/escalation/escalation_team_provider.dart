import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/providers/escalation/escalation_market_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/data/services/escalation_service.dart';

//ESTADO - EQUIPE DE ESCALAÇÃO
class EscalationTeamState {
  final List<int?> starters;
  final List<int?> reserves;
  final int selectedPlayer;
  final String selectedOccupation;
  final int capitan;

  const EscalationTeamState({
    this.starters = const [],
    this.reserves = const [],
    this.selectedPlayer = 0,
    this.selectedOccupation = '',
    this.capitan = 0,
  });

  EscalationTeamState copyWith({
    List<int?>? starters,
    List<int?>? reserves,
    int? selectedPlayer,
    String? selectedOccupation,
    int? capitan,
  }) => EscalationTeamState(
    starters: starters ?? this.starters,
    reserves: reserves ?? this.reserves,
    selectedPlayer: selectedPlayer ?? this.selectedPlayer,
    selectedOccupation: selectedOccupation ?? this.selectedOccupation,
    capitan: capitan ?? this.capitan,
  );
}

//NOTIFICADOR - EQUIPE DE ESCALAÇÃO
class EscalationTeamNotifier extends Notifier<EscalationTeamState> {
  
  @override
  EscalationTeamState build() => const EscalationTeamState();
  final EscalationService _escalationService = EscalationService();

  //FUNÇÃO DE DEFINIÇÃO DE LINEUP DE EQUIPE
  void setLineup(List<int?> starters, List<int?> reserves, String category) {
    final num = _escalationService.numPlayers[category];
    state = state.copyWith(
      starters: starters.isNotEmpty ? starters : List<int?>.filled(num!['starters']!, null),
      reserves: reserves.isNotEmpty ? reserves : List<int?>.filled(num!['reserves']!, null),
    );
  }

  //FUNÇÃO DE DEFINIÇÃO DE JOGADOR SELECIONADO
  void setSelectedPlayer(int index, String occupation) {
    state = state.copyWith(selectedPlayer: index, selectedOccupation: occupation);
  }

  //FUNÇÃO DE ESCALAÇÃO DE JOGADOR NA EQUIPE (TITULAR / RESERVA)
  void setPlayerEscalation(int id) {
    final marketSession = ref.read(escalationMarketProvider);
    final managerSession = ref.read(escalationSessionProvider);
    
    //LISTA DE ESCALADOS
    List<int?> starters = state.starters;
    List<int?> reserves = state.reserves;

    //INDEX DE ID NA LISTA
    final starterIdx = starters.indexOf(id);
    final reserveIdx = reserves.indexOf(id);
    
    //BUSCAR USUARIO
    final user = marketSession.playersMarket.firstWhere((u) => u.id == id);

    final isEscaled = findPlayerEscalation(id);
    try {
      //RESERVAS NÃO DEBITMA DO PATRIMONIO
      if (isEscaled) {
        final price = user.player?.ratings?.firstWhere((r) => 
          r.eventId == managerSession.event?.id, 
          orElse: () => user.player!.ratings!.first).price ?? 0.0;
        //CALCULAR GASTO DE ECONOMIA
        calcEconomy(price, isEscaled ? 'remove' : 'add');
      }

      if (starterIdx != -1) {
        // REMOVE JOGADOR TITULAR
        starters[starterIdx] = null;
      } else if (reserveIdx != -1) {
        // REMOVE JOGADOR RESERVA
        reserves[reserveIdx] = null;
      } else {
        // ADICIONAR JOGADOR
        if (state.selectedOccupation == 'starters') {
          starters[state.selectedPlayer] = id;
        } else {
          reserves[state.selectedPlayer] = id;
        }
      }

      state = state.copyWith(
        starters: starters,
        reserves: reserves,
        selectedPlayer: 0,
        selectedOccupation: '',
      );
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, AppHelper.extractErrorMessage(e));
    }
  }

  //FUNÇÃO DE DEFINIÇÃO DE JOGADOR COMO CAPITÃO
  void setPlayerCapitan(dynamic id) {
    try {
      if (findPlayerEscalation(id)) {
        state = state.copyWith(
          capitan: state.capitan == id ? 0 : id,
        );
      }
    } catch (e) {
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) AppHelper.feedbackMessage(ctx, 'Houve um erro, Tente novamente!');
    }
  }

  //FUNÇÃO DE BUSCA DE JOGADOR NA ESCALAÇÃO
  bool findPlayerEscalation(int id) {
    return state.starters.any((p) => p != null && p == id) ||
        state.reserves.any((p) => p != null && p == id);
  }

  //FUNÇÃO DE CALCULO DE PREÇO DA EQUIPE
  void calcEconomy(double price, String action) {
    final managerSession = ref.read(escalationSessionProvider);
    final sessionNotifier = ref.read(escalationSessionProvider.notifier);
    final rounded = double.parse(price.toStringAsFixed(2));
    if (action == 'add') {
      sessionNotifier.state = managerSession.copyWith(
        price: double.parse((managerSession.price + rounded).toStringAsFixed(2)),
        economy: double.parse((managerSession.economy - rounded).toStringAsFixed(2)),
      );
    } else {
      sessionNotifier.state = managerSession.copyWith(
        price: double.parse((managerSession.price - rounded).toStringAsFixed(2)),
        economy: double.parse((managerSession.economy + rounded).toStringAsFixed(2)),
      );
    }
  }
}

//PROVIDER - EQUIPE DE ESCALAÇÃO
final escalationTeamProvider = NotifierProvider<EscalationTeamNotifier, EscalationTeamState>(EscalationTeamNotifier.new);
