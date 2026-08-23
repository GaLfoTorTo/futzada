import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/api/api_client.dart';
import 'package:esportly/core/api/api_routes.dart';
import 'package:esportly/data/models/event_model.dart';

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
    final events = resp.data ?? [];
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
}