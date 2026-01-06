import 'dart:math';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

import 'package:faker/faker.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/news_model.dart';

class NewsService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  NewsModel generateNews() {
    //GERAR NUMERO ALEATORIO PARA INDEX DE EMBLEMA
    int index = Random().nextInt(8);
    //GERAR TIPO DE NOTICIA
    final type = NewsType.values[Random().nextInt(12)];
    //GERAR EQUIPE (TIME)
    return NewsModel.fromMap({
      "id": index,
      "title" : getEventNews(type)['title'],
      "description": faker.lorem.sentence().toString(),
      "type": type,
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
    });
  }

  //FUNÇÃO DE MAPEAMENTO DE NOTICIAS
  Map<String, dynamic> getEventNews(NewsType type){
    switch (type) {
      case NewsType.EventRegister:
        return {
          "icon" : Icons.new_label,
          "title" : "Registro",
          "color" : AppColors.green_300,
        };
      case NewsType.EventUpdate:
        return {
          "icon" : Icons.update,
          "title" : "Atualização",
          "color" : AppColors.blue_300,
        };
      case NewsType.EventLocation:
        return {
          "icon" : Icons.add_location_alt_sharp,
          "title" : "Alteração de Localização",
          "color" : AppColors.blue_300,
        };
      case NewsType.EventConfig:
        return {
          "icon" : Icons.settings,
          "title" : "Alteração de Configurações",
          "color" : AppColors.blue_300,
        };
      case NewsType.EventGameDay:
        return {
          "icon" : Icons.play_arrow_rounded,
          "title" : "Dia de Jogo",
          "color" : AppColors.green_300,
        };
      case NewsType.EventGame:
        return {
          "icon" : Icons.sports_soccer_rounded,
          "title" : "Partida",
          "color" : AppColors.green_300,
        };
      case NewsType.EventNewRule:
        return {
          "icon" : Icons.post_add_rounded,
          "title" : "Nova Regra",
          "color" : AppColors.green_300,
        };
      case NewsType.EventAlterRule:
        return {
          "icon" : Icons.content_paste_go_rounded,
          "title" : "Atualização Regra",
          "color" : AppColors.blue_300,
        };
      case NewsType.EventRemoveRule:
        return {
          "icon" : Icons.content_paste_off_rounded,
          "title" : "Remoção de Regra",
          "color" : AppColors.red_300,
        };
      case NewsType.ParticipantAdd:
        return {
          "icon" : Icons.person_add_alt_1_rounded,
          "title" : "Novo Participante",
          "color" : AppColors.green_300,
        };
      case NewsType.ParticipantRemove:
        return {
          "icon" : Icons.person_off_rounded,
          "title" : "Participante Removido",
          "color" : AppColors.red_300,
        };
      case NewsType.ParticipantLeft:
        return {
          "icon" : Icons.person_off_rounded,
          "title" : "Participante Saiu",
          "color" : AppColors.gray_500,
        };
      case NewsType.ParticipantChange:
        return {
          "icon" : Icons.manage_accounts_sharp,
          "title" : "Alteração de Participante",
          "color" : AppColors.green_300,
        };
    }
  }
}