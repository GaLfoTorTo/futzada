import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/api/api_client.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/services/news_service.dart';
import 'package:esportly/data/services/avaliation_service.dart';
import 'package:esportly/data/repositories/event_repository.dart';
import 'package:esportly/presentation/controllers/game_controller.dart';
import 'package:esportly/core/providers/game/game_session_provider.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_config_mixin.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_overview_mixin.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_participants_mixin.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_rank_mixin.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_register_mixin.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_rule_mixin.dart';

abstract class EventBase {
  EventRepository get eventRepository;
  AvaliationService get avaliationService;
  ApiClient get apiClient;
  NewsService get newsService;
  UserModel get user;
  List<EventModel> get events;
  EventModel get event;
  set event(EventModel event);
  bool get hasEvent;
  Map<String, List<UserModel>?> get participants;
  String get travelMode;
  set travelMode(String v);
}

class EventController extends ChangeNotifier
  with
    EventOverviewMixin,
    EventConfigMixin,
    EventRegisterMixin,
    EventRankMixin,
    EventParticipantsMixin,
    EventRulesMixin
  implements EventBase {

  static EventController get instance => sl<EventController>();

  @override
  final EventRepository eventRepository = EventRepository();
  @override
  final AvaliationService avaliationService = AvaliationService();
  @override
  final ApiClient apiClient = ApiClient();
  @override
  final NewsService newsService = NewsService();
  @override
  final UserModel user = sl<UserModel>(instanceName: 'user');
  @override
  final List<EventModel> events = sl<List<EventModel>>(instanceName: 'events');

  EventModel? _event;
  @override
  EventModel get event => _event!;
  @override
  set event(EventModel e) { _event = e; notifyListeners(); }
  @override
  bool get hasEvent => _event != null;

  @override
  late Map<String, List<UserModel>?> participants;

  String _travelMode = 'walking';
  @override
  String get travelMode => _travelMode;
  @override
  set travelMode(String v) { _travelMode = v; notifyListeners(); }

  void init() {
    if (!hasEvent && events.isNotEmpty) {
      setSelectedEvent(events.first);
    }
  }

  void setSelectedEvent(EventModel event) {
    this.event = event;
    // Atualiza GameSessionProvider (Riverpod) — páginas migradas
    sl<ProviderContainer>()
        .read(gameSessionProvider.notifier)
        .setEvent(event);
    // Atualiza GameController (GetIt) — páginas ainda não migradas
    GameController.instance.event = event;
    GameController.instance.currentGameConfig = event.gameConfig;
  }
}
