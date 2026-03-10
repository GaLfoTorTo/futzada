//===MIXIN - PARTICIPANTS===
import 'package:flutter/widgets.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:get/get.dart';

mixin EventParticipantsMixin on GetxController{
  //FUNÇÃO DE CATEGORIZAÇÃO DE PARTICIPANTS
  Map<String, List<UserModel>?> setParticipants(List<UserModel>? participants){
    Map<String, List<UserModel>?> map = {
      'Organizador': [],
      'Colaboradores': [],
      'Participantes' : []
    };
    if(participants != null && participants.isNotEmpty){
      participants.forEach((item){
        if(item.participants!.first.role != null){
          //VERIFICAR SE PARTICIPANTE E O ORGANIZADOR
          if(item.participants!.first.role!.contains(Roles.Organizator.name)){
            map['Organizador']?.add(item); 
          //VERIFICAR SE PARTICIPANTE E COLABORADOR
          }else if(item.participants!.first.role!.contains(Roles.Colaborator.name)){
            map['Colaboradores']?.add(item);
          //VERIFICAR SE PARTICIPANTE E JOGADOR
          }else {
            map['Participantes']?.add(item);
          }
        }
      });
    }
    return map;
  }

  //CONTROLADOR DE INPUT DE PESQUISA
  final TextEditingController pesquisaController = TextEditingController();
}