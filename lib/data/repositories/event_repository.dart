import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/services/event_service.dart';

class EventRepository {
  //SERVIÇOS - USUARIO, CACHE LOCAL
  final EventService remoteService = EventService();
  final List<EventModel> _cache = <EventModel>[];

  @override
  Future<List<EventModel>?> getEvents() async {
    if (_cache.isNotEmpty) return _cache;
    try {
      final events = await remoteService.fetchEvents();
      _cache..clear()..addAll(events);
      return events;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return [];
    }
  }

  @override
  Future<EventModel?> getEventById(int id) async {
    if (_cache.isNotEmpty) {
      return _cache.firstWhere((u) => u.id == id);
    }
    try {
      final event = await remoteService.fetchEventById(id);
      _cache..clear()..add(event);
      return event;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return null;
    }
  }

  @override
  Future<List<EventModel>> getUserEvents(int? userId) async {
    if (_cache.isNotEmpty) return _cache;
    try {
      final events = await remoteService.fetchUserEvents(userId);
      _cache..clear()..addAll(events);
      return events;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return [];
    }
  }
}
