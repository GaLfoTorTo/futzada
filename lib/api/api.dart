import 'package:get/get.dart';

class AppApi {
  //URL BASE DAS REQUISIÇÕES
  static const uri = 'http://192.168.15.9:8000';
  static const url = 'http://192.168.15.9:8000/api/';
  //ROTAS DE USUÁRIO
  static const createUser = 'user/create';
  static const editUser = 'user/edit/';
  //ROTAS DE EVENTO
  static const createEvent = 'event/create';
  static const editEvent = 'event/edit/';
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