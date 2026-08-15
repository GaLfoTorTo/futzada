import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:futzada/core/storage/app_storage.dart';
import 'package:futzada/core/providers/app_session_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:futzada/data/services/auth_service.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/app_controller.dart';
import 'package:futzada/presentation/controllers/theme_controller.dart';

class AuthController{
  //CONTROLLERS - AUTH E THEME
  static AuthController get instance => sl<AuthController>();
  final ThemeController themeController = sl<ThemeController>();

  //GETTER - SERVIÇOS
  final AuthService authService = AuthService();

  //GETTER - SESSÃO DO USUÁRIO
  AppSessionNotifier get session => sl<ProviderContainer>().read(appSessionProvider.notifier);

  //INPUT CONTROLLERS - TEXTO
  final TextEditingController userController = TextEditingController(text: '');
  final TextEditingController passwordController = TextEditingController(text: '');
  
  //FUNÇÃO DE INICIALIZAÇÃO DE AUTENTICAÇÃO - VERIFICA SESSÃO LOCAL
  Future<void> boot() async {
    if (!AppStorage.hasData("user")) {
      session.setUnauthenticated();
      return;
    }
    final user = UserModel.fromJson(AppStorage.read("user") as String);
    themeController.setModality(user.config?.mainModality?.name ?? "Football");
    await sl<AppController>().init(user);
  }

  //FUNÇÃO SE SALVAMENTO DE USUARIO LOCAL
  Future<void>saveUser(Map<String, dynamic> resp)async{
    try {
      final UserModel user = UserModel.fromMap(resp['user']);
      final String token = resp['token'];
      //PERSISTIR
      await AppStorage.write('user', user.toJson());
      await AppStorage.writeIfNull('token', token);
      await AppStorage.write("needsComplete", user.player != null && user.manager != null);
      await boot();
    } catch (e) {
      rethrow;
    }
  }

  //FUNÇÃO DE REMOCAO DE USUÁRIO LOCAL
  Future<void> removeUser() async {
    if(AppStorage.hasData("user")){
      AppStorage.remove("user");
      AppStorage.remove('token');
    }
  }

  //FUNÇÃO DE LIMPEZA DE SESSÃO
  Future<void> clearUser() async{
    if (sl.isRegistered<UserModel>(instanceName: 'user')) sl.unregister<UserModel>(instanceName: 'user');
    if (sl.isRegistered<List<EventModel>>(instanceName: 'events')) sl.unregister<List<EventModel>>(instanceName: 'events');
    if (sl.isRegistered<Position>(instanceName: 'position')) sl.unregister<Position>(instanceName: 'position');
    if (sl.isRegistered<LatLng>(instanceName: 'latlng')) sl.unregister<LatLng>(instanceName: 'latlng');
    if (sl.isRegistered<Map<String, dynamic>>(instanceName: 'location')) sl.unregister<Map<String, dynamic>>(instanceName: 'location');
    //REMOVER USUSARIO LOCAL
    await removeUser();
  }

  //FUNÇÃO DE LOGIN (GOOGLE)
  Future<void>google() async {
    //INICIALIZAR AUTHENTICAÇÃO COM GOOGLE PELO EMAIL
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email','profile'],
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'],
    );
    //TENTAR LOGAR
    try {
      //EFETUAR LOGIN NO GOOGLE
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if(googleUser == null) throw('Houve um erro ao tentar efetuar login, tente novamente.');

      //OBTER TOKENS DE AUTENTICAÇÃO DO GOOGLE
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) throw('Houve um erro ao tentar efetuar login, tente novamente.');
      
      //BUSCAR USUARIO NA BASE DO FUTZADA
      final formData = {
        "id_token" : googleAuth.idToken,
        "type" : 'google'
      };
      final resp = await authService.userFetchLogin(formData);
      if (resp.status != 200) {
        await googleSignIn.signOut();
        await removeUser();
        return;
      }
      
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      await saveUser(resp.data);
    } catch (e) {
      await googleSignIn.signOut();
      await removeUser();
    }
  }

  //FUNÇÃO DE LOGIN (BASE FUTZADA)
  Future<void>platform() async {
    //TENTAR LOGAR
    try {
      //BUSCAR USARIO NO BANCO
      final formData = {
        'user': userController.text, 
        'password': passwordController.text,
        "type" : 'platform'
      };
      final resp = await authService.userFetchLogin(formData);
      if (resp.status != 200) {
        await removeUser();
      }

      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE (AGUARDAR COMPLETAMENTE)
      await saveUser(resp.data);
    } catch (_) {
      removeUser();
    }
  }
  
  //FUNÇÃO DE LOGIN (FACEBOOK)
  Future<void>facebook() async {
    return;
  }

  //FUNÇÃO DE LOGIN 
  Future<void>login({String? type}) async {
    switch (type) {
      case 'google':
        await google();
      case 'facebook':
        await facebook();
      default:
        await platform();
    }
  }
  
  //FUNÇÃO DE LOGOUT
  Future<void>logout() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      await googleSignIn.signOut();
      await clearUser();
    } on DioException catch (_) {
      await removeUser();
    } finally {
      session.setUnauthenticated();
    }
  }
}