import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/services/rank_service.dart';

//ESTADO - RANKING DO EVENTO
class EventRankState {
  final bool ready;
  final bool error;
  final bool loading;
  final EventModel? event;
  final List<UserModel> topRanking;
  final String type;

  const EventRankState({
    this.ready = false,
    this.error = false,
    this.loading = false,
    this.event,
    this.topRanking = const [],
    this.type = 'Artilheiros',
  });

  EventRankState copyWith({
    bool? ready,
    bool? error,
    bool? loading,
    EventModel? event,
    List<UserModel>? topRanking,
    String? type,
  }) => EventRankState(
    ready: ready ?? this.ready,
    error: error ?? this.error,
    loading: loading ?? this.loading,
    event: event ?? this.event,
    topRanking: topRanking ?? this.topRanking,
    type: type ?? this.type,
  );
}

//NOTIFICADOR - RANKING DO EVENTO
class EventRankNotifier extends Notifier<EventRankState> {
  RankService get _rankService => RankService();

  @override
  EventRankState build() => const EventRankState();

  void init(EventModel event){
    state = state.copyWith(event: event);
  }

  EventRankState _buildRanking(EventModel event) {
    if (event.participants == null || event.participants!.isEmpty) return const EventRankState();
    final participants = event.participants!
        .where((u) => u.participants?.isNotEmpty ?? false)
        .map((u) => u.participants!.first)
        .toList();
    if (participants.isEmpty) return const EventRankState();
    final generated = _rankService.generateRank(
      participants.length.clamp(0, 10),
      participants,
    );
    final ranked = generated
        .map((p) => event.participants!.firstWhere((u) => u.participants!.first == p))
        .toList();
    return EventRankState(topRanking: ranked);
  }

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
    state = _buildRanking(event);
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
