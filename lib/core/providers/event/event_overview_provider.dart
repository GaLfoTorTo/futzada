import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/repositories/event_repository.dart';

//ESTADO - VISÃO GERAL / SUGESTÕES DE EVENTOS
class EventOverviewState {
  final List<EventModel> suggestions;
  final bool isLoading;
  final String? error;

  const EventOverviewState({
    this.suggestions = const [],
    this.isLoading = false,
    this.error,
  });

  EventOverviewState copyWith({
    List<EventModel>? suggestions,
    bool? isLoading,
    String? error,
  }) => EventOverviewState(
    suggestions: suggestions ?? this.suggestions,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

//NOTIFICADOR - VISÃO GERAL
class EventOverviewNotifier extends Notifier<EventOverviewState> {
  EventRepository get _repository => EventRepository();

  @override
  EventOverviewState build() => const EventOverviewState();

  //BUSCA SUGESTÕES DE EVENTOS DO SERVIDOR
  Future<void> loadSuggestions() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final events = await _repository.getEvents();
      state = state.copyWith(
        suggestions: events ?? [],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  //LIMPA AS SUGESTÕES CARREGADAS
  void clearSuggestions() {
    state = const EventOverviewState();
  }
}

//PROVIDER - VISÃO GERAL DO EVENTO
final eventOverviewProvider = NotifierProvider<EventOverviewNotifier, EventOverviewState>(
  EventOverviewNotifier.new,
);
