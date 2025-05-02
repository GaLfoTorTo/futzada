import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static ChatController get instace => Get.find();
  //CONTROLADOR DE INPUT DE PESQUISA
  final TextEditingController pesquisaController = TextEditingController();
  //LISTA DE AMIGOS
  final RxList<Map<String, dynamic>> friends = [
    for(var i = 0; i <= 15; i++)
      {
        'id': i,
        'nome': 'Jeferson Vasconcelos',
        'userName': 'jeff_vasc',
        'posicao': null,
        'foto': null,
        'checked': false,
      },
  ].obs;
}