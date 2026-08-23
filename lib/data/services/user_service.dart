import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/api/api_client.dart';
import 'package:esportly/core/api/api_response.dart';
import 'package:esportly/core/api/api_routes.dart';
import 'package:esportly/data/models/user_model.dart';


class UserService {
  //CLIENTE HTTP
  ApiClient apiClient = sl<ApiClient>();
  
  //REQUISIÇÃO - BUSCAR SUGESTÃO DE AMIGOS
  Future<List<UserModel>> usersSuggestionFetch() async {
    //BUSCAR USUARIO
    final resp = await apiClient.get(ApiRoutes.users);
    return resp.data.map((json) => UserModel.fromJson(json));
  }

  //REQUISIÇÃO - BUSCA DE DADOS DO USUARIO
  Future<UserModel> userFetch(int id) async{
    //BUSCAR USUARIO
    final resp = await apiClient.get(ApiRoutes.getUrl("${ApiRoutes.user}id"));
    return UserModel.fromJson(resp.data);
  }

  //REQUISIÇÃO - CRIAÇÃO DE USUARIO
  Future<ApiResponse> userRegister(data) async {
    //ENVIAR FORMULÁRIO
    return await apiClient.post(ApiRoutes.userCreate, data);
  }
}