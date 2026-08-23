import 'package:esportly/core/api/api_client.dart';
import 'package:esportly/core/api/api_response.dart';
import 'package:esportly/core/api/api_routes.dart';

class AuthService { 
  //CLIENT HTTP
  ApiClient apiClient = ApiClient();

  //FUNÇÃO DE LOGIN E BUSCA DE DADOS DO USUARIO
  Future<ApiResponse> userFetchLogin(Map<String, dynamic> data) async{
    return await apiClient.post(ApiRoutes.login, data);
  }
}