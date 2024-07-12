import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:futzada/models/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futzada/api/api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthController {
  UsuarioModel? _user;

  UsuarioModel get usuario => _user!;

  //FUNÇÃO DE CONFIGURAÇÕES DE USUÁRIO LOCALMENTE
  void setUser(BuildContext context, UsuarioModel? usuario) {
    //VERIFICAR SE USUÁRIO RECEBIDO NÃO ESTA VAZIO
    if(usuario != null){
      _user = usuario;
      //SALVAR LOCALMENTE
      saveUser(usuario);
      //NAVEGAR PARA HOME PAGE
      Navigator.pushReplacementNamed(context, "/home");
    }else{
      //NAVEGAR PARA LOGIN PAGE
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  //FUNÇÃO DE SALVAMENTO DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> saveUser(UsuarioModel usuario) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //SALVAR USUARIO LOCALMENTE
    await storage.setString('usuario', usuario.toJson());
    return;
  }

  //FUNÇÃO DE REMOVER DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> removeUser(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //REMOVER USUARIO LOCALMENTE
      storage.remove("usuario");
      setUser(context, null);
    }
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<void> hasUser(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final usuario = storage.get('usuario') as String;
      setUser(context, UsuarioModel.fromJson(usuario));
    }else{
      setUser(context, null);
    }
    return;
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<UsuarioModel?> getUser(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final usuario = storage.get('usuario') as String;
      //VERIFICAR SE USUARIO NÃO ESTA VAZIO
      if (usuario != null) {
        return UsuarioModel.fromJson(usuario);
      }
    }
    return null;
  }

  //FUNÇÃO DE LOGIN COM GOOLGE
  Future<void>googleLogin(BuildContext context) async {
    //INICIALIZAR AUTHENTICAÇÃO COM GOOGLE PELO EMAIL
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    //TENTAR LOGAR
    try {
      //ENVIAR SOLICITAÇÃO AO GOOGLE
      final resp = await googleSignIn.signIn();
      //RESGATAR NOME DE USUÁRIO E FOTO
      final usuario = UsuarioModel(
        nome: resp!.displayName!,
        foto: resp.photoUrl
      );
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      setUser(context, usuario);
    } catch (e) {
      setUser(context, null);
    }
  }

  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>login(BuildContext context, String user, String password) async {
   //BUSCAR URL BASICA
    var url = Uri.parse('${AppApi.url}login');
    //TENTAR SALVAR USUÁRIO
    try {
      //INICIALIZAR REQUISIÇÃO
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user': user,
          'password': password,
        }),
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RESGATAR OS DADOS DE USUARIO
        UsuarioModel usuario = UsuarioModel();
        //RESGATAR DADOS RECEBIDOS
        Map<String, dynamic>data = jsonDecode(response.body);
        //GERAR MODEL DE USUARIO APARTIR DE DADOS RECEBIDOS
        usuario = usuario.copyWithMap(updates: data['usuario']);
        //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
        setUser(context, usuario);
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
        };
      } else {
        //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
        setUser(context, null);
        //RESGATAR MENSAGEM DE ERRO
        var errorMessage = jsonDecode(response.body);
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 401,
          'message': errorMessage['message'],
        };
      }
    } catch (e) {
      //RETORNAR MENSAGEM DE ERRO NO ENVIO DOS DADOS
      return {
        'status': 400,
        'message':'Erro ao efetuar login.'
      };
    }
  }
  
  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>logout(BuildContext context) async {
   //BUSCAR URL BASICA
    var url = Uri.parse('${AppApi.url}logout');
    //TENTAR SALVAR USUÁRIO
    try {
      //RESGATAR USUARIO SALVO LOCALMENTE
      var usuario = await getUser(context);
      //RESGATAR UUID DO USUARIO LOCALMENTE
      String? uuid = usuario!.uuid;
      //RESGATAR TOKEN JWT DO USUARIO LOCALMENTE
      String? token = usuario!.token;
      //INICIALIZAR REQUISIÇÃO
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'uuid': uuid,
        }),
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
        removeUser(context);
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
        };
      } else {
        //RESGATAR MENSAGEM DE ERRO
        var errorMessage = jsonDecode(response.body);
        print(errorMessage);
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 500,
          'message': errorMessage['message'],
        };
      }
    } catch (e) {
        print(e);
      //RETORNAR MENSAGEM DE ERRO NO ENVIO DOS DADOS
      return {
        'status': 400,
        'message':'Erro ao efetuar o logout.'
      };
    }
  }
}