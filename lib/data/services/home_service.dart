import 'package:futzada/core/api/api_client.dart';
import 'package:futzada/core/api/api_routes.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';

class HomeService {

  //CLIENTE HTTP
  ApiClient apiClient = ApiClient();
  
  //FUNÇÃO PARA SIMNULAR BUSCA DE PELADAS RECOMENDADAS
  Future<Map<String, dynamic>> fetchHome() async {
    final resp = await apiClient.get(ApiRoutes.home);
    return Map.fromEntries(
      (resp.data as Map<String, dynamic>).entries.map((entry) {
        return MapEntry(
          entry.key,
          entry.key != "friends"
            ? List<EventModel>.from(entry.value['items']?.map((e) => EventModel.fromMap(e as Map<String, dynamic>)) ?? [])
            : List<UserModel>.from(entry.value['items']?.map((e) => UserModel.fromMap(e as Map<String, dynamic>)) ?? [])
        );
      }),
    );
  }
}