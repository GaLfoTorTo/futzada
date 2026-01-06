import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:futzada/services/manager_service.dart';
import 'package:get/get.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:futzada/controllers/theme_controller.dart';
import 'package:futzada/services/form_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/user_model.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AuthController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static AuthController get instance => Get.find();
  //GETTER - SERVIÇO DE FORMULÁRIO
  final FormService formService = FormService();
  //GETTER DE STORAGE
  final storage = GetStorage();
  //GETTER DE MODEL DE USUARIO
  final Rxn<UserModel> user = Rxn<UserModel>();
  //CONTROLLERS DE CADA CAMPO
  final TextEditingController userController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

  //ON READY
  @override
  void onReady(){
    //REMOVER SPLASH
    FlutterNativeSplash.remove();
    //VERIFICAR SE USUÁRIO JA ESTÁ LOGADO
    hasUser();
    //INICIALIZAR CONTROLLER DE TEMA
    Get.put(ThemeController(), permanent: true);
  }

  //FUNÇÃO PARA VERIFICAÇÃO DE EXISTENCIA DE USUÁRIO SALVO LOCALMENTE
  Future<void> hasUser() async{
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.hasData("user")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final userData = await storage.read('user') as String;
      //DEFINIR USUARIO
      setUser(UserModel.fromJson(userData));
    }else{
      //RETORNAR STATUS
      setUser(null);
    }
  }

  //FUNÇÃO DE DEFINIÇÃO DE USUÁRIO LOCALMENTE
  Future<void> setUser(UserModel? user) async {
    //VERIFICAR SE USUÁRIO RECEBIDO NÃO ESTA VAZIO
    if(user != null){
      //ADICIONAR DADOS DE TECNICO (TEMPORARIAMENTE)
      user.manager = ManagerService().generateManager(user.id);
      //SALVAR USUARIO LOCAL
      await storage.writeIfNull('user', user.toJson());
      //ADICIONAR AO GLOBALMENT AO GET USUARIO
      Get.put(user, tag: 'user', permanent: true);
      //VERIFICAR SE É O PRIMEIRO LOGIN
      if(!storage.hasData('firstLogin')){
        //NAVEGAR PARA APRESENTAÇÃO PAGE
        Get.offAllNamed('/apresentacao');
        //DEFINIR FIRST LOGIN PARA FALSE
        storage.writeIfNull('firstLogin', false);
      }else{
        //NAVEGAR PARA APRESENTAÇÃO PAGE
        Get.offAllNamed('/home');
      }
    }else{
      //REMOVER USUARIO LOCAL
      if(storage.hasData("user")){
        //REMOVER USUARIO LOCALMENTE
        storage.remove("user");
      }
      //VERIFICAR ROTA ATUAL
      if (Get.currentRoute != '/login') {
        //NAVEGAR PARA LOGIN PAGE
        Get.offAllNamed('/login');
      }
    }
  }
  
  //FUNÇÃO PARA RECUPERAR USUÁRIO SALVO LOCALMENTE
  Future<UserModel?> getUser() async{
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.hasData("user")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final userData = storage.read('user') as String;
      //RETORNAR USUARIO EM FORMATO DE JSON
      return UserModel.fromJson(userData);
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
      String? firstName = resp?.displayName?.split(' ')[0] ?? 'Usuario';
      String? lastName = resp?.displayName?.split(' ').skip(1).join(' ') ?? 'Anônimo';
      //CRIAR NOVA INSTANCIA DE USUARIO COM DADOS DO GOOGLE
      final user = UserModel(
        firstName: firstName,
        lastName: lastName,
        email: resp?.email,
        photo: resp?.photoUrl,
      );
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      setUser(user);
      //RETORNAR SUCESSO
      return{'status' : 200};
    } catch (e) {
      setUser(null);
      //RETORNAR MENSAGEM DE ERRO NO LOGIN DO GOOGLE
      return {
        'status': 401,
        'message': 'Não foi possível fazer login com o Google, tente novamente!',
      };
    }
  }

  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>login() async {
    //BUSCAR URL BASICA
    var url = '${AppApi.url}login';
    //RESGATAR LOGIN E SENHA
    String user = userController.text;
    String password = passwordController.text;
    // CRIAR OBJETO JSON
    var data = jsonEncode({'user': user, 'password': password});
    //RESGATAR OPTIONS
    var options = await FormService.setOption(null);
    //ENVIAR FORMULÁRIO
    var response = await FormService.sendData(data, options, url);
    //VERIFICAR RESPOSTA DO SERVIDOR
    if(response['status'] == 200) {
      //RESGATAR OS DADOS DE USUARIO
      UserModel user = UserModel.fromMap(response['data']['user']);
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      setUser(user);
      //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
      return {'status': 200};
    } else {
      //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
      setUser(null);
      //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
      return {
        'status': 401,
        'message': response['message'],
      };
    }
  }
  
  //FUNÇÃO DE LOGOUT
  Future<Map<String, dynamic>>logout() async {
    //BUSCAR URL BASICA
    var url = '${AppApi.url}logout';
    //TENTAR SALVAR USUÁRIO
    try {
      //RESGATAR USUARIO SALVO LOCAMENTE
      var user = await getUser();
      //RESGATAR OPTIONS
      var options = await FormService.setOption(user);
      //VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
      if (user != null) {
        // CRIAR OBJETO JSON
        var data = jsonEncode({'uuid': user.uuid});
        //ENVIAR FORMULÁRIO
        var response = await FormService.sendData(data, options, url);
        //VERIFICAR RESPOSTA DO SERVIDOR
        if(response['status'] == 200) {
          //REMOVER USUÁRIO LOCAL
          setUser(null);
          //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
          return {'status': 200};
        } else {
          //REMOVER USUÁRIO LOCAL
          setUser(null);
          //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
          return {
            'status': 401,
            'message': response['message'],
          };
        }
      } else {
        //EFETUAR LOGOUT DO GOOGLE
        GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
        //REMOVER USUÁRIO LOCAL
        setUser(null);
        //RETORNAR STATUS DE SUCCESSO
        return {'status': 200};
      }
    } on DioException catch (e) {
      //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
      setUser(null);
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }

  //FUNÇÃO DE VALIDAÇÃO DE EMAIL 
  String? validateUser(){
    //VERIFICAR SE EMAIL OU USUÁRIO NÃO ESTÁ VAZIO
    if(userController.text.isEmpty){
      return "O e-mail ou nome de usuário deve ser informados!";
    }
    return null;
  }

  //FUNÇÃO DE VALIDAÇÃO DE SENHA
  String? validatePassword(){
    //VERIFICAR SE password NÃO ESTÁ VAZIO
    if(passwordController.text.isEmpty){
      return "A senha deve ser Informada!";
    }
    return null;
  }
}