import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/api/api_client.dart';
import 'package:esportly/core/api/api_routes.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/game_model.dart';
import 'package:esportly/data/models/news_model.dart';
import 'package:esportly/data/models/rule_model.dart';
import 'package:esportly/data/models/user_model.dart';

class EventService {
  //INSTANCIAR SERVIÇOS - API
  ApiClient apiClient = sl<ApiClient>();

  //FUNÇÃO DE BUSCA EVENTO ESPECIFICO
  Future<EventModel> fetchEventById(int id) async{
    final resp = await apiClient.get("${ApiRoutes.events}$id");
    return EventModel.fromJson(resp.data);
  }
  
  //FUNÇÃO DE BUSCA DE TODOS OS EVENTOS
  Future<List<EventModel>> fetchEvents() async{
    final resp = await apiClient.get(ApiRoutes.events);
    final events = resp.data['events'] ?? [];
    return events
      .map<EventModel>((e) => EventModel.fromMap(e))
      .toList();
  }

  //FUNÇÃO DE BUSCA DE DADOS DO USUARIO
  Future<List<EventModel>> fetchUserEvents(int? userId) async{
    final resp = await apiClient.get(ApiRoutes.userEvent);
    final events = resp.data['events'] ?? [];
    return events
      .map<EventModel>((e) => EventModel.fromMap(e))
      .toList();
  }
  
  //FUNÇÃO DE BUSCA DE DADOS DE RANKING
  Future<List<UserModel>?> fetchRankEvent(int? id, String type) async{
    final resp = await apiClient.get("${ApiRoutes.events}$id/rank/$type");
    final rank = resp.data['rank'] ?? [];
    return rank
      .map<UserModel>((e) => UserModel.fromMap(e))
      .toList();
  }
  
  //FUNÇÃO DE BUSCA DE DADOS DE REGRAS DA PELADA
  Future<List<RuleModel>?> fetchRulesEvent(int? id,) async{
    final resp = await apiClient.get("${ApiRoutes.events}$id/rules");
    final rules = resp.data['rules'] ?? [];
    return rules
      .map<RuleModel>((e) => RuleModel.fromMap(e))
      .toList();
  }
  
  //FUNÇÃO DE BUSCA DE DADOS DE REGRAS DA PELADA
  Future<List<NewsModel>?> fetchNewsEvent(int? id,) async{
    final resp = await apiClient.get("${ApiRoutes.events}$id/news");
    final news = resp.data['news'] ?? [];
    return news
      .map<NewsModel>((e) => NewsModel.fromMap(e))
      .toList();
  }

  //FUNÇÃO DE BUSCA DE PARTIDAS DA PELADA
  Future<List<GameModel>?> fetchGamesEvent(int? id,) async{
    final resp = await apiClient.get("${ApiRoutes.events}$id/games");
    final news = resp.data['news'] ?? [];
    return news
      .map<GameModel>((e) => GameModel.fromMap(e))
      .toList();
  }
  
  //FUNÇÃO DE BUSCA DE PARTIDAS DA PELADA
  Future<List<GameModel>?> fetchHistoricEvent(int? id,) async{
    final resp = await apiClient.get("${ApiRoutes.events}$id/historic");
    final news = resp.data['news'] ?? [];
    return news
      .map<GameModel>((e) => GameModel.fromMap(e))
      .toList();
  }
}