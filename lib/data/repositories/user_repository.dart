import 'package:flutter/foundation.dart';
import 'package:esportly/core/api/api_response.dart';
import 'package:esportly/core/storage/app_storage.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/user_service.dart';

class UserRepository {
  //SERVIÇOS - USUARIO, CACHE LOCAL
  final UserService remoteService = UserService();
  final List<UserModel> _cache = <UserModel>[];
  
  //CHAMADA - BUSCA DE USUARIO
  Future<UserModel> getUser(int id) async {
    //VERIFICAR SE CACHE ESTA VAZIO
    if (_cache.isNotEmpty) {
      //USUARIO EM CACHE
      return _cache.firstWhere((u) => u.id == id); 
    }
    
    try {
      //BUSCAR USUARIO
      final user = await remoteService.userFetch(id);
      //ADICICONAR AO CACHE
      _cache.add(user);
      return user;
    } catch (e) {
      //BUSCAR USUARIOS NO STORAGE LOCAL
      debugPrint('API failed, using local data: $e');
      return UserModel.fromJson(AppStorage.read<String>("user") ?? '{}');
    }
  }
  
  //CHAMADA - REGISTRO DE USUÁRIO
  Future<ApiResponse> registerUser(Map<String, dynamic> form) async {
    return await remoteService.userRegister(form);
  }
}