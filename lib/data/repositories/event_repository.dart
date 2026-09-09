import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/game_model.dart';
import 'package:esportly/data/models/rule_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/event_service.dart';

class EventRepository {
  //SERVIÇOS - USUARIO, CACHE LOCAL
  final EventService remoteService = EventService();
  final List<EventModel> _cache = <EventModel>[];

  //BUSCAR EVENTOS
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

  //BUSCAR EVENTOS POR ID
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

  //BUSCAR EVENTOS DO USUARIO
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

  //BUSCAR RANKING APARTIR DO TIPO
  @override
  Future<List<UserModel>?> getRankEvent(int id, String type) async {
    try {
      final participants = await remoteService.fetchRankEvent(id, type);
      return participants;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return null;
    }
  }
  
  //BUSCAR REGRAS DO EVENTO
  @override
  Future<List<RuleModel>?> getRulesEvent(int id) async {
    try {
      final rules = await remoteService.fetchRulesEvent(id);
      return rules;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return null;
    }
  }

  //BUSCAR PARTIDAS DO EVENTO
  @override
  Future<List<GameModel>?> getGamesEvent(int id) async {
    try {
      final games = await remoteService.fetchGamesEvent(id);
      return games;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return null;
    }
  }
  
  //BUSCAR HISTÓRICO DE PARTIDAS DO EVENTO
  @override
  Future<List<GameModel>?> geHistoricEvent(int id) async {
    try {
      final games = await remoteService.fetchHistoricEvent(id);
      return games;
    } catch (e, stackTrace) {
      print('=== ERRO COMPLETO ===');
      print('Erro: $e');
      print('Stack trace: $stackTrace');
      print('=====================');
      return null;
    }
  }
}