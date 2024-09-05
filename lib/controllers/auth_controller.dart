import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AuthController extends getx.GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static AuthController get instance => getx.Get.find();
  //INSTANCIA DE MODEL DE USUARIO
  final _usuario = getx.Rxn<UsuarioModel>();
  //GETTER DE MODEL DE USUARIO
  UsuarioModel? get usuario => _usuario.value;
  //INSTANCIAR STORAGE
  final storage = GetStorage();
  //ON READY
  @override
  void onReady(){
    //REMOVER SPLASH
    FlutterNativeSplash.remove();
    //FLAG DE PRIMEIRO LOGIN DO USUARIO NO APP
    storage.writeIfNull('firstLogin', true);
    //VERIFICAR SE USUÁRIO JA ESTÁ LOGADO
    hasUsuario();
  }

  //FUNÇÃO DE CONFIGURAÇÕES DE USUÁRIO LOCALMENTE
  void setUsuario(UsuarioModel? usuario) {
    //VERIFICAR SE USUÁRIO RECEBIDO NÃO ESTA VAZIO
    if(usuario != null){
      _usuario.value = usuario;
      //SALVAR LOCALMENTE
      saveUsuario(usuario);
      //VERIFICAR SE É O PRIMEIRO LOGIN
      if(storage.read('firstLogin') == true){
        //NAVEGAR PARA APRESENTAÇÃO PAGE
        getx.Get.offAllNamed('/apresentacao');
        //DEFINIR FIRST LOGIN PARA FALSE
        storage.write('firstLogin', false);
      }else{
        //NAVEGAR PARA APRESENTAÇÃO PAGE
        getx.Get.offAllNamed('/home');
      }
    }else{
      //NAVEGAR PARA LOGIN PAGE
      getx.Get.offAllNamed('/login');
    }
  }

  //FUNÇÃO DE SALVAMENTO DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> saveUsuario(UsuarioModel usuario) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //SALVAR USUARIO LOCALMENTE
    await storage.setString('usuario', usuario.toJson());
  }

  //FUNÇÃO DE REMOVER DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> removeUsuario() async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //VERIFICAR SE EXISTE A CHAVE USUARIO LOCALMENTE
    if(storage.containsKey("usuario")){
      //REMOVER USUARIO LOCALMENTE
      storage.remove("usuario");
      setUsuario(null);
    }
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<void> hasUsuario() async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final usuarioData = storage.get('usuario') as String;
      //DEFINIR USUARIO
      setUsuario(UsuarioModel.fromJson(usuarioData));
    }else{
      //RETORNAR STATUS
      setUsuario(null);
    }
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<UsuarioModel?> getUsuario() async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("usuario")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final usuarioData = storage.get('usuario') as String;
      //RETORNAR USUARIO EM FORMATO DE JSON
      return UsuarioModel.fromJson(usuarioData);
    }
    return null;
  }

  //FUNÇÃO DE LOGIN COM GOOLGE
  Future<Map<String, dynamic>>googleLogin(BuildContext context) async {
    //INICIALIZAR AUTHENTICAÇÃO COM GOOGLE PELO EMAIL
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    //TENTAR LOGAR
    try {
      //ENVIAR SOLICITAÇÃO AO GOOGLE
      final resp = await googleSignIn.signIn();
      //RESGATAR DADOS DO USUÁRIO FORNECIDOS PELO GOOGLE
      String? nome = resp?.displayName?.split(' ')[0] ?? 'Usuario';
      String? sobrenome = resp?.displayName?.split(' ').skip(1).join(' ') ?? 'Anônimo';
      //CRIAR NOVA INSTANCIA DE USUARIO COM DADOS DO GOOGLE
      final usuario = UsuarioModel(
        nome: nome,
        sobrenome: sobrenome,
        email: resp?.email,
        foto: resp?.photoUrl,
      );
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      setUsuario(usuario);
      //RETORNAR SUCESSO
      return{'status' : 200};
    } catch (e) {
      setUsuario(null);
      //RETORNAR MENSAGEM DE ERRO NO LOGIN DO GOOGLE
      return {
        'status': 401,
        'message': 'Não foi possível fazer login com o Google, tente novamente!',
      };
    }
  }

  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>login(String user, String password) async {
   //BUSCAR URL BASICA
    var url = '${AppApi.url}login';
    //TENTAR SALVAR USUÁRIO
    try {
      //INSTANCIAR DIO
      var dio = Dio();
      dio.options.connectTimeout = const Duration(seconds: 30);
      dio.options.receiveTimeout = const Duration(seconds: 30);
      // CRIAR OBJETO JSON
      var data = jsonEncode({'user': user, 'password': password});
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
        UsuarioModel usuario = UsuarioModel.fromMap(response.data['usuario']);
        //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
        setUsuario(usuario);
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {'status': 200};
      } else {
        //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
        setUsuario(null);
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 401,
          'message': response.data['message'],
        };
      }
    } on DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
  
  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>logout() async {
    //BUSCAR URL BASICA
    var url = '${AppApi.url}logout';
    //TENTAR SALVAR USUÁRIO
    try {
      //RESGATAR USUARIO SALVO LOCAMENTE
      var usuario = await getUsuario();
      //VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
      if (usuario != null) {
        //CONFIGURAR DIO
        var dio = Dio();
        dio.options.connectTimeout = const Duration(seconds: 5);
        dio.options.receiveTimeout = const Duration(seconds: 5);
        //ENVIAR REQUISIÇÃO DE LOGOUT
        var response = await dio.post(
          url,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${usuario.token}'
            },
          ),
          data: FormData.fromMap({'uuid': usuario.uuid}),
        );
        //VERIFICAR STATUS DE RESPOSTA
        if (response.statusCode == 200) {
          //REMOVER USUÁRIO LOCAL
          removeUsuario();
          //RETORNAR STATUS DE SUCCESSO
          return {'status': 200};
        } else {
          //RETORNAR STATUS DE ERRO
          return {
            'status': 500,
            'message': response.data['message'],
          };
        }
      } else {
        //EFETUAR LOGOUT DO GOOGLE
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        //RETORNAR STATUS DE SUCCESSO
        return {'status': 200};
      }
    } on DioException catch (e) {
      //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
      removeUsuario();
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
}