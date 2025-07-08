import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:futzada/services/form_service.dart';
import 'package:get/get.dart' as getx;
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AuthController extends getx.GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static AuthController get instance => getx.Get.find();
  //GETTER - SERVIÇO DE FORMULÁRIO
  FormService formService = FormService();
  //INSTANCIA DE MODEL DE USUARIO
  final _user = getx.Rxn<UserModel>();
  //GETTER DE MODEL DE USUARIO
  UserModel? get user => _user.value;
  //INSTANCIAR STORAGE
  final storage = GetStorage();
  //CONTROLLERS DE CADA CAMPO
  final TextEditingController userController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');

  //ON READY
  @override
  void onReady(){
    //REMOVER SPLASH
    FlutterNativeSplash.remove();
    //FLAG DE PRIMEIRO LOGIN DO USUARIO NO APP
    storage.writeIfNull('firstLogin', true);
    //VERIFICAR SE USUÁRIO JA ESTÁ LOGADO
    hasUser();
  }

  //FUNÇÃO DE CONFIGURAÇÕES DE USUÁRIO LOCALMENTE
  void setUser(UserModel? user) async {
    //VERIFICAR SE USUÁRIO RECEBIDO NÃO ESTA VAZIO
    if(user != null){
      //ATUALIZAR VALOR DE USUARIO NO CONTROLLER
      _user.value = user;
      //SALVAR USUARIO LOCAL
      await saveUser(user);
      //ADICIONAR AO GLOBALMENT AO GET USUARIO
      getx.Get.put(user, tag: 'user', permanent: true);
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
      //REMOVER USUARIO LOCAL
      await removeUser();
      //VERIFICAR ROTA ATUAL
      if (getx.Get.currentRoute != '/login') {
        //NAVEGAR PARA LOGIN PAGE
        getx.Get.offAllNamed('/login');
      }
    }
  }

  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<void> hasUser() async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("user")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final userData = storage.get('user') as String;
      //DEFINIR USUARIO
      setUser(UserModel.fromJson(userData));
    }else{
      //RETORNAR STATUS
      setUser(null);
    }
  }

  //FUNÇÃO DE SALVAMENTO DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> saveUser(UserModel user) async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //SALVAR USUARIO LOCALMENTE
    await storage.setString('user', user.toJson());
  }

  //FUNÇÃO DE REMOVER DE DADOS DO USUÁRIO LOCALMENTE
  Future<void> removeUser() async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    //VERIFICAR SE EXISTE A CHAVE USUARIO LOCALMENTE
    if(storage.containsKey("user")){
      //REMOVER USUARIO LOCALMENTE
      storage.remove("user");
    }
  }
  
  //FUNÇÃO PARA VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
  Future<UserModel?> getUser() async{
    //INSTANCIAR STORAGE
    final storage = await SharedPreferences.getInstance();
    await Future.delayed(Duration(seconds: 2));
    //VERIFICAR SE EXISTE A CHAVE USER LOCALMENTE
    if(storage.containsKey("user")){
      //RESGATAR DADOS SALVOS DO USUARIO
      final userData = storage.get('user') as String;
      //RETORNAR USUARIO EM FORMATO DE JSON
      return UserModel.fromJson(userData);
    }
    return null;
  }

  //VALIDAÇÃO DE EMAIL E password
  String? validateUser(){
    //VERIFICAR SE EMAIL OU USUÁRIO NÃO ESTÁ VAZIO
    if(userController.text.isEmpty){
      return "O e-mail ou nome de usuário deve ser informados!";
    }
    return null;
  }

  String? validatePassword(){
    //VERIFICAR SE password NÃO ESTÁ VAZIO
    if(passwordController.text.isEmpty){
      return "A senha deve ser Informada!";
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
  
  //FUNÇÃO DE LOGIN 
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
}