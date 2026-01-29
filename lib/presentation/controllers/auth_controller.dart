import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/api/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:futzada/data/services/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:futzada/data/repositories/user_repository.dart';
import 'package:futzada/presentation/controllers/theme_controller.dart';
import 'package:futzada/presentation/controllers/app_controller.dart';
import 'package:futzada/presentation/controllers/navigation_controller.dart';
import 'package:futzada/presentation/controllers/user_controller.dart';

class AuthController extends GetxController{
  //CONTROLLERS - AUTH E THEME
  static AuthController get instance => Get.find();
  final ThemeController themeController = ThemeController.instance;
  //GETTER - SERVIÇOS E RESPOSITORIES
  final ApiService apiService = ApiService();
  final UserRepository userRepository = UserRepository();
  
  //GETTER - STORAGE, MODEL USUARIO
  final storage = GetStorage();
  final Rxn<UserModel> user = Rxn<UserModel>();
  final RxBool isAuthenticated = false.obs;

  //CONTROLLERS - TEXTO
  final TextEditingController userController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');
  
  @override
  void onReady() {
    super.onReady();
    //REMOVER SPLASH
    FlutterNativeSplash.remove();
  }

  @override
  void onInit() {
    super.onInit();
    //DEFINIR USUARIO LOGADO
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser();
    });
  }
  
  @override
  void onClose() {
    super.onClose();
  }

  //FUNÇÃO DE BUSCA DE USUARIO LOCAL
  Future<void> getUser()async{
    if(storage.hasData("user")){
      final user = UserModel.fromJson(storage.read("user") as String);
      Get.put(user, tag: 'user', permanent: true);
      isAuthenticated.value = true;
      Get.put(AppController());
    }
  }

  //FUNÇÃO SE SALVAMENTO DE USUARIO LOCAL
  Future<void>saveUser(UserModel user)async{
    await storage.write('user', user.toJson());
    themeController.setModality(user.config?.mainModality!.name ?? "Football");
    getUser();
  }

  //FUNÇÃO DE REMOCAO DE USUÁRIO LOCAL
  Future<void> removeUser() async {
    if(storage.hasData("user")){
      storage.remove("user");
      storage.remove('token');
    }
  }

  //FUNÇÃO DE LOGIN COM GOOLGE (OLD TESTES)
  Future<Map<String, dynamic>>googleLogin(BuildContext context) async {
    //INICIALIZAR AUTHENTICAÇÃO COM GOOGLE PELO EMAIL
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    //TENTAR LOGAR
    try {
      //ENVIAR SOLICITAÇÃO AO GOOGLE
      final resp = await googleSignIn.signIn();
      //RESGATAR USUARIO
      final user = await userRepository.getUserGoogle(resp);
      if(user != null){
        //VERIFICAR SE DADOS DE PLAYER E MANAGER JA FORAM CONFIGURADOS
        storage.write("needsComplete", user.player != null && user.manager != null);
        //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
        saveUser(user);
        //RETORNAR SUCESSO
        return{'status' : 200};
      }
      return {'status': 401,'message': 'Não foi possível fazer login com o Google, tente novamente!'};
    } catch (e) {
      removeUser();
      //RETORNAR MENSAGEM DE ERRO NO LOGIN DO GOOGLE
      return {'status': 401,'message': 'Não foi possível fazer login com o Google, tente novamente!'};
    }
  }
  
  //FUNÇÃO DE LOGIN COM GOOLGE
  Future<Map<String, dynamic>>loginGoogle(BuildContext context) async {
    //INICIALIZAR AUTHENTICAÇÃO COM GOOGLE PELO EMAIL
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email','profile'],
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    );
    //TENTAR LOGAR
    try {
      //EFETUAR LOGIN COM GOOGLE
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if(googleUser == null) return {'status': 401, 'message': 'Houve um erro ao tentar fazer login com o google, tente novamente.'};

      //OBTER TOKENS DE AUTENTICAÇÃO DO GOOGLE
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) return {'status': 401, 'message': 'Houve um erro ao tentar fazer login com o google, tente novamente.'};

      //VERIFICAÇÃO DE BACKEND DE LOGIN DO GOOGLE
      var resp = await ApiService.post(
        {"id_token": googleAuth.idToken}, 
        AppApi.getUrl(AppApi.loginGoogle)
      );

      //CRIAR NOVA INSTANCIA DE USUARIO COM DADOS DO GOOGLE VERIFICADOS
      if (resp["status"] == 200) {
        final user = UserModel.fromMap(resp["data"]["user"]);
        //SALVAR TOKEN LOCALMENTE
        await storage.writeIfNull('token', resp['data']['token']);
        //VERIFICAR SE DADOS DE PLAYER E MANAGER JA FORAM CONFIGURADOS
        storage.write("needsComplete", user.player != null && user.manager != null);
        //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
        saveUser(user);
        //RETORNAR SUCESSO
        return{'status' : 200};
      }
      //RETORNAR MENSAGEM DE ERRO
      return{'status' : 400, 'message': 'Não foi possível fazer login com o Google, tente novamente!',};
    } catch (e) {
      //LIMPAR SEÇÕES ANTERIORES
      await googleSignIn.signOut();
      removeUser();
      //RETORNAR MENSAGEM DE ERRO
      return {'status': 401, 'message': 'Não foi possível fazer login com o Google, tente novamente!'};
    }
  }

  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>login() async {
    //ENVIAR FORMULÁRIO
    var resp = await ApiService.post(
      {'user': userController.text, 'password': passwordController.text}, 
      AppApi.getUrl(AppApi.login)
    );
    //VERIFICAR RESPOSTA DO SERVIDOR
    if(resp['status'] == 200) {
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      saveUser(UserModel.fromMap(resp['data']['user']));
      //SALVAR TOKEN LOCALMENTE
      await storage.writeIfNull('token', resp['data']['token']);
      //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
      return {'status': 200};
    } else {
      //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
      removeUser();
      //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
      return {'status': 401,'message': resp['message']};
    }
  }
  
  //FUNÇÃO DE LOGOUT
  Future<Map<String, dynamic>>logout() async {
    ///INICIALIZAR SERVIÇO DE AUTHENTICAÇÃO COM GOOGLE
    GoogleSignIn googleSignIn = GoogleSignIn();
    //TENTAR SALVAR USUÁRIO
    try {
      //LOGPOUT GOOGLE
      await googleSignIn.signOut();
      //REMOVER USUSARIO LOCAL
      await removeUser();
      //REMOVER DADOS PERMANENTS DA MEMORIA
      Get.delete(tag: 'user', force: true);
      Get.delete(tag: 'events', force: true);
      Get.delete(tag: 'userPosition', force: true);
      Get.delete(tag: 'userLatLog', force: true);
      Get.delete(tag: 'userLocation', force: true);
      Get.delete<UserController>(force: true);
      Get.delete<AppController>(force: true);
      Get.delete<NavigationController>(force: true);
      Get.offAllNamed('/login');
      //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
      return {'status': 200};
    } on DioException catch (e) {
      //REMOVER INFORMAÇÕES DO USUÁRIO LOCALMENTE
      await removeUser();
      Get.offAllNamed('/login');
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
}