import 'package:esportly/data/models/news_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/event_model.dart';

//ESTADO - PARTICIPANTES DO EVENTO
class EventNewsState {
  final bool ready;
  final bool error;
  final bool loading;
  final EventModel? event;
  final List<NewsModel>? news;

  const EventNewsState({
    this.ready = false,
    this.error = false,
    this.loading = false,
    this.event,
    this.news = const[],
  });

  EventNewsState copyWith({
    bool? ready,
    bool? error,
    bool? loading,
    EventModel? event,
    List<NewsModel>? rules,
  }) => EventNewsState(
    ready: ready ?? this.ready,
    error: error ?? this.error,
    loading: loading ?? this.loading,
    event: event ?? this.event,
    news: news ?? this.news,
  );
}

//NOTIFICADOR - PARTICIPANTES DO EVENTO
class EventNewsNotifier extends Notifier<EventNewsState> {

  @override
  EventNewsState build() => const EventNewsState();

  //FUNÇÃO DE INICIALIZAÇÃO
  void init(EventModel event){ 
    state = state.copyWith(
      event: event,
    );
  }
}

//PROVIDER - PARTICIPANTES DO EVENTO
final eventNewsProvider = NotifierProvider<EventNewsNotifier, EventNewsState>(EventNewsNotifier.new);
