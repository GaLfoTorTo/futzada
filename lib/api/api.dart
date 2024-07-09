import 'package:flutter/material.dart';

class AppApi {
  //URL BASE DAS REQUISIÇÕES
  static final url = 'http://192.168.15.7:8000/api/';
  static const token = 'lknasLBNubk909UASD79hoAISO';//RESGATAR TOKEN SALVO NO DISPOSITIVO DO USUARIO
  //ROTAS DE USUÁRIO
  static const createUser = 'user/create';
  static const editUser = 'user/edit/';
}