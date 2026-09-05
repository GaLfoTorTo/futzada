import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/api/api_client.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/services/news_service.dart';
import 'package:esportly/data/services/avaliation_service.dart';
import 'package:esportly/data/repositories/event_repository.dart';
import 'package:esportly/core/providers/event/event_session_provider.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_config_mixin.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_register_mixin.dart';
import 'package:esportly/presentation/controllers/mixin/event/event_rule_mixin.dart';

class EventController extends ChangeNotifier
  with
    EventConfigMixin,
    EventRegisterMixin,
    EventRulesMixin {

  static EventController get instance => sl<EventController>();

  final EventRepository eventRepository = EventRepository();
  final AvaliationService avaliationService = AvaliationService();
  final ApiClient apiClient = ApiClient();
  final NewsService newsService = NewsService();
  final UserModel user = sl<UserModel>(instanceName: 'user');
  final List<EventModel> events = sl<List<EventModel>>(instanceName: 'events');

  EventModel? get currentEvent => sl<ProviderContainer>().read(eventSessionProvider).event;
}
