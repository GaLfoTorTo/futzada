import 'dart:math';
import 'package:faker/faker.dart' as fakerData;
import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/services/event_service.dart';
import 'package:futzada/theme/app_colors.dart';

class HomeService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();
  //INSTANCIAR SERVIÇO DE EVENTOS
  EventService eventService = EventService();
  
  //COR DE BACKGROUND PADRÃO PARA CARDS DE EVENTOS
  final Color backgroundColorDefault = AppColors.dark_500;
  //COR DE TEXTO PADRÃO PARA CARDS DE EVENTOS
  final Color textColorDefault = AppColors.white;
  //GRADIENTE PADRÃO PARA CARDS DE EVENTOS
  final LinearGradient gradientDefault = LinearGradient(
    colors: [
      AppColors.dark_500.withAlpha(50),
      AppColors.dark_500,
    ],
    begin: Alignment.center,
    end: Alignment.bottomCenter,
  );
  
  //FUNÇÃO PARA SIMNULAR BUSCA DE PELADAS RECOMENDADAS
  Future<List<Map<String, dynamic>>> fetchCloseEvents() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //ARRAY DE EVENTOS
    List<Map<String, dynamic>> arr = [];
    //GERAR EVENTOS (TEMPORAREAMENTE)
    List.generate(random.nextInt(5), (i){
      //RESGATAR UM EVENTO
      EventModel event = eventService.generateEvent(i);
      //INICIALIZAR PELADAS
      arr.add({
        "event" : event,
        "distancia":"${random.nextInt(5)} Km",
        "gradient": gradientDefault,
        "textColor" : textColorDefault,
      });
    });
    //RETORNAR ARRAY DE EVENTOS
    return arr;
  }

  //FUNÇÃO PARA SIMULAR BUSCA DE PELADAS MAIS POPULARES
  Future<void>fecthPopular() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //ARRAY DE EVENTOS
    List<Map<String, dynamic>> arr = [];
    //GERAR EVENTOS (TEMPORAREAMENTE)
    List.generate(random.nextInt(5), (i){
      //RESGATAR UM EVENTO
      EventModel event = eventService.generateEvent(i);
      //INICIALIZAR PELADAS
      arr.add({
        "event" : event,
        "distancia":"${random.nextInt(5)} Km",
        "gradient": gradientDefault,
        "textColor" : textColorDefault,
      });
    });
  }
  
  //FUNÇÃO PARA SIMULAR BUSCA DE TOP PELADAS
  Future<void>fecthTopRanking() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    //INICIALIZAR TOP RANKING
  }
  
  //FUNÇÃO PARA SIMULAR BUSCA DE ULTIMOS JOGOS DO USUARIO
  Future<void>fecthUltimosJogos() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(Duration(seconds: 2));
    
  }
}