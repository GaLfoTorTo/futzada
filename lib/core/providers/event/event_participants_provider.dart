import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/enum/enums.dart';
import 'package:esportly/data/models/user_model.dart';

//ESTADO - PARTICIPANTES DO EVENTO
class EventParticipantsState {
  final Map<String, List<UserModel>?> participants;

  const EventParticipantsState({
    this.participants = const {
      'Organizador': [],
      'Colaboradores': [],
      'Participantes': [],
    },
  });

  EventParticipantsState copyWith({
    Map<String, List<UserModel>?>? participants,
  }) => EventParticipantsState(
    participants: participants ?? this.participants,
  );
}

//NOTIFICADOR - PARTICIPANTES DO EVENTO
class EventParticipantsNotifier extends Notifier<EventParticipantsState> {
  final TextEditingController pesquisaController = TextEditingController();

  @override
  EventParticipantsState build() => const EventParticipantsState();

  //FUNÇÃO DE CATEGORIZAÇÃO DE PARTICIPANTES
  void setParticipants(List<UserModel>? participants) {
    Map<String, List<UserModel>?> map = {
      'Organizador': [],
      'Colaboradores': [],
      'Participantes': [],
    };
    if (participants != null && participants.isNotEmpty) {
      for (final item in participants) {
        if (item.participants?.first.role != null) {
          if (item.participants!.first.role!.contains(Roles.Organizator.name)) {
            map['Organizador']?.add(item);
          } else if (item.participants!.first.role!.contains(Roles.Colaborator.name)) {
            map['Colaboradores']?.add(item);
          } else {
            map['Participantes']?.add(item);
          }
        }
      }
    }
    state = state.copyWith(participants: map);
  }
}

//PROVIDER - PARTICIPANTES DO EVENTO
final eventParticipantsProvider = NotifierProvider<EventParticipantsNotifier, EventParticipantsState>(EventParticipantsNotifier.new);
