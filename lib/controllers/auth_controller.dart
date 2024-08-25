import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'dart:convert';
import 'package:futzada/models/usuario_model.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:futzada/api/api.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  UsuarioModel? _usuario;

  UsuarioModel get usuario => _usuario!;

  //FUNÇÃO DE CONFIGURAÇÕES DE USUÁRIO LOCALMENTE
  void setUsuario(BuildContext context, UsuarioModel? usuario) {
    //VERIFICAR SE USUÁRIO RECEBIDO NÃO ESTA VAZIO
    if(usuario != null){
      _usuario = usuario;
      //SALVAR LOCALMENTE
      saveUsuario(usuario);
      //INICIALIZAR DADOS DO PROVIDER 
      Provider.of<UsuarioProvider>(context, listen: false).loadUser(context);
      //NAVEGAR PARA APRESENTAÇÃO PAGE
      Navigator.pushReplacementNamed(context, "/home");
    }else{
      //NAVEGAR PARA LOGIN PAGE
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  //FUNÇÃO DE SALVAMENTO DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> saveUsuario(UsuarioModel usuario) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //SALVAR USUARIO LOCALMENTE
    await storage.setString('usuario', usuario.toJson());
    return;
  }

  //FUNÇÃO DE REMOVER DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> removeUsuario(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //REMOVER USUARIO LOCALMENTE
      storage.remove("usuario");
      setUsuario(context, null);
    }
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<void> hasUsuario(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final usuario = storage.get('usuario') as String;
      setUsuario(context, UsuarioModel.fromJson(usuario));
    }else{
      setUsuario(context, null);
    }
    return;
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<UsuarioModel?> getUsuario(BuildContext context) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final usuario = storage.get('usuario') as String;
      //RETORNAR USUARIO EM FORMATO DE JSON
      return UsuarioModel.fromJson(usuario);
    }
    return null;
  }

  //FUNÇÃO DE LOGIN COM GOOLGE
  Future<void>googleLogin(BuildContext context) async {
    //INICIALIZAR AUTHENTICAÇÃO COM GOOGLE PELO EMAIL
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
      'email',
    ]);
    //TENTAR LOGAR
    try {
      //ENVIAR SOLICITAÇÃO AO GOOGLE
      final resp = await googleSignIn.signIn();
      String? nome;
      String? sobrenome;
      //VERIFICAR SE NOME DO USUARIO NÃO ESTA VAZIO
      if(resp!.displayName != null){
        //RESGATAR DADOS DO USUARIO VINDOS DO GOOGLE
        var nome_completo = resp.displayName!.split(' ');
        nome = nome_completo[0];
        sobrenome = nome_completo.contains(1) ? nome_completo[1] : '';
      }else{
        nome = 'Usuario';
        sobrenome = 'Anônimo';
      }
      //RESGATAR DADOS DO USUÁRIO FORNECIDOS PELO GOOGLE
      final usuario = UsuarioModel(
        nome: nome,
        sobrenome: sobrenome,
        email: resp.email,
        foto: resp.photoUrl
      );
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      setUsuario(context, usuario);
    } catch (e) {
      setUsuario(context, null);
    }
  }

  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>login(BuildContext context, String user, String password) async {
   //BUSCAR URL BASICA
    var url = '${AppApi.url}login';
    //TENTAR SALVAR USUÁRIO
    try {
      //INSTANCIAR DIO
      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      // CRIAR OBJETO JSON
      var data = jsonEncode({
        'user': user,
        'password': password,
      });
      // INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: data,
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RESGATAR OS DADOS DE USUARIO
        UsuarioModel usuario = UsuarioModel();
        //RESGATAR DADOS RECEBIDOS
        Map<String, dynamic> data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
        //GERAR MODEL DE USUARIO APARTIR DE DADOS RECEBIDOS
        usuario = usuario.copyWithMap(updates: data['usuario']);
        //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
        setUsuario(context, usuario);
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
        };
      } else {
        //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
        setUsuario(context, null);
        //RESGATAR MENSAGEM DE ERRO
        var errorMessage = response.data is String
            ? jsonDecode(response.data)
            : response.data;
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 401,
          'message': errorMessage['message'],
        };
      }
    } on DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
  
  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>logout(BuildContext context) async {
    //BUSCAR URL BASICA
    var url = '${AppApi.url}logout';
    //TENTAR SALVAR USUÁRIO
    try {
      //RESGATAR USUARIO SALVO LOCALMENTE
      var usuario = await getUsuario(context);
      //RESGATAR UUID DO USUARIO LOCALMENTE
      String? uuid = usuario!.uuid;
      //RESGATAR TOKEN JWT DO USUARIO LOCALMENTE
      String? token = usuario.token;
      //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
      removeUsuario(context);
      //VERIFICAR SE UUID E TOKEN EXISTEM NO LOCAL
      if(uuid != null && token != null){ 
        //INSTANCIAR DIO
        var dio = Dio();
        dio.options.connectTimeout = const Duration(seconds: 5);
        dio.options.receiveTimeout = const Duration(seconds: 5);
        //INICIALIZAR REQUISIÇÃO
        var response = await dio.post(
          url, 
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            },
          ),
          data: FormData.fromMap({
            'uuid': uuid
          }),
        );
        //VERIFICAR RESPOSTA DO SERVIDOR
        if(response.statusCode == 200) {
          //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
          return {
            'status': 200,
          };
        } else {
          //RESGATAR MENSAGEM DE ERRO
          var errorMessage = response.data is String
              ? jsonDecode(response.data)
              : response.data;
          //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
          return {
            'status': 500,
            'message': errorMessage['message'],
          };
        }
      }else{
        //INICIALIZAR GOOGLE SIGN IN
        GoogleSignIn googleSignIn = GoogleSignIn();
        //EFETUAR LOG OUT DA CONTA DO GOOGLE
        await googleSignIn.signOut();
    
      }
      return {
        'status': 200,
      };
    } on DioException catch (e) {
      //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
      removeUsuario(context);
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
}