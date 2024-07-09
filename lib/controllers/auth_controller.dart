import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  UserModel? _user;

  UserModel get user => _user!;

  //FUNÇÃO DE CONFIGURAÇÕES DE USUÁRIO LOCALMENTE
  void setUser(BuildContext context, UserModel? user) {
    //VERIFICAR SE USUÁRIO RECEBIDO NÃO ESTA VAZIO
    if(user != null){
      _user = user;
      //SALVAR LOCALMENTE
      saveUser(user);
      //NAVEGAR PARA HOME PAGE
      Navigator.pushReplacementNamed(context, "/home");
    }else{
      //NAVEGAR PARA LOGIN PAGE
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  //FUNÇÃO DE SALVAMENTO DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> saveUser(UserModel user) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //SALVAR USUARIO LOCALMENTE
    await storage.setString('user', user.toJson());
    return;
  }

  //FUNÇÃO DE REMOVER DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> removeUser(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("user")){
      //REMOVER USUARIO LOCALMENTE
      storage.remove("user");
      setUser(context, null);
    }
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<void> hasUser(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("user")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final user = storage.get('user') as String;
      setUser(context, UserModel.fromJson(user));
    }else{
      setUser(context, null);
    }
    return;
  }
}