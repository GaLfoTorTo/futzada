import 'package:esportly/data/models/event_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/enum/enums.dart';
import 'package:esportly/data/models/user_model.dart';

//ESTADO - PARTICIPANTES DO EVENTO
class EventParticipantsState {
  final bool ready;
  final bool error;
  final bool loading;
  final EventModel? event;
  final Map<String, List<UserModel>?> participants;

  const EventParticipantsState({
    this.ready = false,
    this.error = false,
    this.loading = false,
    this.event,
    this.participants = const {
      'Organizador': [],
      'Colaboradores': [],
      'Participantes': [],
    },
  });

  EventParticipantsState copyWith({
    bool? ready,
    bool? error,
    bool? loading,
    EventModel? event,
    Map<String, List<UserModel>?>? participants,
  }) => EventParticipantsState(
    ready: ready ?? this.ready,
    error: error ?? this.error,
    loading: loading ?? this.loading,
    event: event ?? this.event,
    participants: participants ?? this.participants,
  );
}

//NOTIFICADOR - PARTICIPANTES DO EVENTO
class EventParticipantsNotifier extends Notifier<EventParticipantsState> {
  final TextEditingController pesquisaController = TextEditingController();

  @override
  EventParticipantsState build() => const EventParticipantsState();

  void init(EventModel event){
    state = state.copyWith(event: event);
  }

  EventParticipantsState _categorize(List<UserModel>? participants) {
    final Map<String, List<UserModel>?> map = {
      'Organizador': [],
      'Colaboradores': [],
      'Participantes': [],
    };
    if (participants != null && participants.isNotEmpty) {
      for (final item in participants) {
        if (item.participants?.first.roles != null) {
          if (item.participants!.first.roles!.contains(Roles.Organizator.name)) {
            map['Organizador']?.add(item);
          } else if (item.participants!.first.roles!.contains(Roles.Colaborator.name)) {
            map['Colaboradores']?.add(item);
          } else {
            map['Participantes']?.add(item);
          }
        }
      }
    }
    return EventParticipantsState(participants: map);
  }

  //FUNÇÃO DE CATEGORIZAÇÃO DE PARTICIPANTES
  void setParticipants(List<UserModel>? participants) {
    state = _categorize(participants);
  }
}

//PROVIDER - PARTICIPANTES DO EVENTO
final eventParticipantsProvider = NotifierProvider<EventParticipantsNotifier, EventParticipantsState>(EventParticipantsNotifier.new);
