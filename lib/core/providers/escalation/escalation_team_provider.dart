import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/data/models/user_model.dart';

//ESTADO - EQUIPE DE ESCALAÇÃO
class EscalationTeamState {
  final List<int?> starters;
  final List<int?> reserves;
  final int selectedPlayer;
  final String selectedOccupation;
  final int selectedPlayerCapitan;

  const EscalationTeamState({
    this.starters = const [],
    this.reserves = const [],
    this.selectedPlayer = 0,
    this.selectedOccupation = '',
    this.selectedPlayerCapitan = 0,
  });

  EscalationTeamState copyWith({
    List<int?>? starters,
    List<int?>? reserves,
    int? selectedPlayer,
    String? selectedOccupation,
    int? selectedPlayerCapitan,
  }) => EscalationTeamState(
    starters: starters ?? this.starters,
    reserves: reserves ?? this.reserves,
    selectedPlayer: selectedPlayer ?? this.selectedPlayer,
    selectedOccupation: selectedOccupation ?? this.selectedOccupation,
    selectedPlayerCapitan: selectedPlayerCapitan ?? this.selectedPlayerCapitan,
  );
}

//NOTIFICADOR - EQUIPE DE ESCALAÇÃO
class EscalationTeamNotifier extends Notifier<EscalationTeamState> {
  @override
  EscalationTeamState build() => const EscalationTeamState();

  //FUNÇÃO DE DEFINIÇÃO DE LINEUP DE EQUIPE
  void setLineup(List<int?> starters, List<int?> reserves) {
    state = state.copyWith(
      starters: List<int?>.from(starters),
      reserves: List<int?>.from(reserves),
    );
  }

  //FUNÇÃO DE DEFINIÇÃO DE JOGADOR SELECIONADO
  void setSelectedPlayer(int index, String occupation) {
    state = state.copyWith(selectedPlayer: index, selectedOccupation: occupation);
  }

  //FUNÇÃO DE ESCALAÇÃO DE JOGADOR NA EQUIPE (TITULAR / RESERVA)
  void setPlayerPosition(UserModel player) {
    final starters = List<int?>.from(state.starters);
    final reserves = List<int?>.from(state.reserves);

    final starterIdx = starters.indexOf(player.id);
    final reserveIdx = reserves.indexOf(player.id);

    if (starterIdx != -1) {
      // REMOVE JOGADOR TITULAR
      starters[starterIdx] = null;
    } else if (reserveIdx != -1) {
      // REMOVE JOGADOR RESERVA
      reserves[reserveIdx] = null;
    } else {
      // ADICIONAR JOGADOR
      if (state.selectedOccupation == 'starters') {
        starters[state.selectedPlayer] = player.id;
      } else {
        reserves[state.selectedPlayer] = player.id;
      }
    }

    state = state.copyWith(
      starters: starters,
      reserves: reserves,
      selectedPlayer: 0,
      selectedOccupation: '',
    );
  }

  //FUNÇÃO DE DEFINIÇÃO DE JOGADOR COMO CAPITÃO
  void setPlayerCapitan(dynamic id) {
    try {
      if (findPlayerEscalation(id)) {
        state = state.copyWith(
          selectedPlayerCapitan: state.selectedPlayerCapitan == id ? 0 : id,
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
}

//PROVIDER - EQUIPE DE ESCALAÇÃO
final escalationTeamProvider = NotifierProvider<EscalationTeamNotifier, EscalationTeamState>(EscalationTeamNotifier.new);
