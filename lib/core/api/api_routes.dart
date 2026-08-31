import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiRoutes {
  //URL BASE DAS REQUISIÇÕES
  static String _port() {
    final host = dotenv.env["APP_HOST"];
    return (host != null && !host.contains('esportly')) ? ':${dotenv.env["APP_PORT"]}' : '';
  }
  static String uri() => "${dotenv.env["APP_SCHEME"]}://${dotenv.env["APP_HOST"]}${_port()}";
  static String url() => "${dotenv.env["APP_SCHEME"]}://${dotenv.env["APP_HOST"]}${_port()}/api/";
  //FUNÇÃO PARA GERAR URL (DOMINIO + ROTA)
  static String getUrl(String route) => url() + route;
  //ROTAS DE AUTH
  static const login = "login";
  static const logout = "logout";
  //ROTAS DE USUÁRIO
  static const users = 'users';
  static const user = 'user/';
  static const userCreate = 'user/create';
  static const userEdit = 'user/edit/';
  static const userDelete = 'user/delete/';
  static const userEvent = 'user/events/';
  static const userInfo = 'user/info/';
  //ROTAS DE HOME
  static const home = 'home';
  //ROTAS DE EVENTO
  static const event = 'events/';
  static const events = 'events';
  static const eventCreate = 'events/create';
  static const eventEdit = 'events/edit/';
  static const eventDelete = 'events/delete/';
  static const eventParticipants = 'events/participants/';
  //ROTAS DE MAPAS
  static String mapUrl(Brightness brightness) => brightness == Brightness.dark
    ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png"
    : "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png";
  static const alternativeMap = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  //ROTAS DE PESQUISA DE ENDEREÇOS
  static const mapReverse = "https://nominatim.openstreetmap.org/reverse";
  static const mapSearch = "https://nominatim.openstreetmap.org/search";
  static const mapInterpreter = "https://overpass-api.de/api/interpreter";
}