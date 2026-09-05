import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/services/rank_service.dart';

//ESTADO - RANKING DO EVENTO
class EventRankState {
  final List<UserModel> topRanking;
  final String type;

  const EventRankState({
    this.topRanking = const [],
    this.type = 'Artilheiros',
  });

  EventRankState copyWith({
    List<UserModel>? topRanking,
    String? type,
  }) => EventRankState(
    topRanking: topRanking ?? this.topRanking,
    type: type ?? this.type,
  );
}

//NOTIFICADOR - RANKING DO EVENTO
class EventRankNotifier extends Notifier<EventRankState> {
  RankService get _rankService => RankService();

  @override
  EventRankState build() => const EventRankState();

  //DEFINE O TIPO DE RANKING EXIBIDO (ex.: 'Artilheiros', 'Assistências')
  void setType(String type) {
    state = state.copyWith(type: type);
  }

  //ATUALIZA A LISTA DE RANKING
  void setTopRanking(List<UserModel> list) {
    state = state.copyWith(topRanking: List.from(list));
  }

  //GERA UM RANKING A PARTIR DOS PARTICIPANTES DO EVENTO
  void generateRanking(EventModel event) {
    if (event.participants == null || event.participants!.isEmpty) return;
    final participants = event.participants!
        .where((u) => u.participants?.isNotEmpty ?? false)
        .map((u) => u.participants!.first)
        .toList();
    if (participants.isEmpty) return;
    final generated = _rankService.generateRank(
      participants.length.clamp(0, 10),
      participants,
    );
    // Reconstrói a lista de UserModel a partir dos participantes gerados
    final ranked = generated
        .map((p) => event.participants!.firstWhere((u) => u.participants!.first == p))
        .toList();
    state = state.copyWith(topRanking: ranked);
  }

  //LIMPA O RANKING
  void clear() {
    state = const EventRankState();
  }
}

//PROVIDER - RANKING DO EVENTO
final eventRankProvider = NotifierProvider<EventRankNotifier, EventRankState>(
  EventRankNotifier.new,
);
