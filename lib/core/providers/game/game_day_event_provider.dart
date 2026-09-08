import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/providers/game/game_session_provider.dart';

//ESTADO - GAME DAY
class GameDayEventState {
  final List<UserModel> participantsClone;
  final List<UserModel> participantsPresent;

  const GameDayEventState({
    this.participantsClone = const [],
    this.participantsPresent = const [],
  });

  GameDayEventState copyWith({
    List<UserModel>? participantsClone,
    List<UserModel>? participantsPresent,
  }) => GameDayEventState(
    participantsClone: participantsClone ?? this.participantsClone,
    participantsPresent: participantsPresent ?? this.participantsPresent,
  );
}

//NOTIFICADOR - GAME DAY 
class GameDayEventNotifier extends Notifier<GameDayEventState> {
  @override
  GameDayEventState build() => const GameDayEventState();

  //FUNÇÃO DE AÇÃO DE PARTICIPANTE PRESENTE
  void addParticipantsPresents() {
    final event = ref.read(gameSessionProvider).event;
    if (event?.participants == null) return;

    final present = <UserModel>[];
    for (final user in event!.participants!) {
      final participant = UserHelper.getParticipant(user.participants, event.id!);
      if (user.player != null && participant != null && participant.roles!.contains('Player')) {
        present.add(user);
      }
    }
    state = state.copyWith(participantsClone: present, participantsPresent: present);
  }

  //FUNÇÃO DE DEFINIÇÃO DE PARTICIPANTE PRESENTE
  void setParticipantsPresent(List<UserModel> list) {
    state = state.copyWith(participantsPresent: list);
  }

  //FUNÇÃO DE REORDENAÇÃO DE PARTICIPANTE PRESENTE
  void reorderParticipants(int oldIndex, int newIndex) {
    final list = [...state.participantsPresent];
    final adjusted = newIndex > oldIndex ? newIndex - 1 : newIndex;
    final item = list.removeAt(oldIndex);
    list.insert(adjusted, item);
    state = state.copyWith(participantsPresent: list);
  }
}
//PROVIDER - GAME DAY
final gameDayEventProvider = NotifierProvider<GameDayEventNotifier, GameDayEventState>(GameDayEventNotifier.new);
