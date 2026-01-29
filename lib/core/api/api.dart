import 'package:get/get.dart';

class AppApi {
  //FUNÇÃO PARA GERAR URL (DOMINIO + ROTA)
  static String getUrl(String route) => url + route;
  //URL BASE DAS REQUISIÇÕES
  static const uri = 'http://192.168.15.7:8000/';
  static const url = 'http://10.198.52.124:8000/api/';//'http://192.168.15.7:8000/api/';
  //ROTAS DE AUTH
  static const login = "login";
  static const loginGoogle = "login/google";
  static const logout = "logout";
  //ROTAS DE USUÁRIO
  static const getUsers = 'users';
  static const getUser = 'user/';
  static const createUser = 'user/create';
  static const editUser = 'user/edit/';
  static const deleteUser = 'user/delete/';
  //ROTAS DE EVENTO
  static const getEvent = 'event/';
  static const getEvents = 'events';
  static const createEvent = 'event/create';
  static const editEvent = 'event/edit/';
  static const deleteEvent = 'event/delete/';
  //ROTAS DE MAPAS
  static String get map => Get.isDarkMode
    ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png"
    : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png";
  static const alternativeMap = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  //ROTAS DE PESQUISA DE ENDEREÇOS
  static const mapReverse = "https://nominatim.openstreetmap.org/reverse";
  static const mapSearch = "https://nominatim.openstreetmap.org/search";
  static const mapInterpreter = "https://overpass-api.de/api/interpreter";
}