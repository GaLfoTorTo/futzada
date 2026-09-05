import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/providers/game/game_session_provider.dart';

//ESTADO - SESSÃO DO EVENTO
class EventSessionState {
  final EventModel? event;
  final String travelMode;
  final List<EventModel> events;
  final UserModel? user;

  const EventSessionState({
    this.event,
    this.travelMode = 'walking',
    this.events = const [],
    this.user,
  });

  bool get hasEvent => event != null;

  EventSessionState copyWith({
    EventModel? event,
    String? travelMode,
    List<EventModel>? events,
    UserModel? user,
  }) => EventSessionState(
    event: event ?? this.event,
    travelMode: travelMode ?? this.travelMode,
    events: events ?? this.events,
    user: user ?? this.user,
  );
}

//NOTIFICADOR - SESSÃO DO EVENTO
class EventSessionNotifier extends Notifier<EventSessionState> {
  @override
  EventSessionState build() => EventSessionState(
    events: sl.isRegistered<List<EventModel>>(instanceName: 'events')
        ? sl<List<EventModel>>(instanceName: 'events')
        : const [],
    user: sl.isRegistered<UserModel>(instanceName: 'user')
        ? sl<UserModel>(instanceName: 'user')
        : null,
  );

  //FUNÇÃO DE DEFINIÇÃO DO EVENTO SELECIONADO
  void setSelectedEvent(EventModel event) {
    state = state.copyWith(event: event);
    ref.read(gameSessionProvider.notifier).setEvent(event);
  }

  //FUNÇÃO DE DEFINIÇÃO DO MODO DE VIAGEM
  void setTravelMode(String mode) {
    state = state.copyWith(travelMode: mode);
  }

  //FUNÇÃO DE INICIALIZAÇÃO (auto-seleciona o primeiro evento se necessário)
  void init() {
    if (!state.hasEvent && state.events.isNotEmpty) {
      setSelectedEvent(state.events.first);
    }
  }
}

//PROVIDER - SESSÃO DO EVENTO
final eventSessionProvider = NotifierProvider<EventSessionNotifier, EventSessionState>(
  EventSessionNotifier.new,
);
