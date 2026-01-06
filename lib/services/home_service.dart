import 'dart:math';
import 'package:faker/faker.dart' as fakerData;
import 'package:futzada/models/event_model.dart';
import 'package:futzada/services/event_service.dart';

class HomeService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = fakerData.Faker();
  static var random = Random();
  //INSTANCIAR SERVIÇO DE EVENTOS
  EventService eventService = EventService();
  
  //FUNÇÃO PARA SIMNULAR BUSCA DE PELADAS RECOMENDADAS
  Future<List<EventModel>> fetchToYou() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(const Duration(seconds: 2));
    //ARRAY DE EVENTOS
    List<EventModel> arr = [];
    //GERAR EVENTOS (TEMPORAREAMENTE)
    List.generate(random.nextInt(5), (i){
      //INICIALIZAR PELADAS
      arr.add(eventService.generateEvent(i));
    });
    //RETORNAR ARRAY DE EVENTOS
    return arr;
  }
  //FUNÇÃO PARA SIMNULAR BUSCA DE PELADAS RECOMENDADAS
  Future<List<EventModel>> fetchFakeEvent() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(const Duration(seconds: 2));
    //ARRAY DE EVENTOS
    List<EventModel> arr = [];
    //GERAR EVENTOS (TEMPORAREAMENTE)
    List.generate(random.nextInt(5), (i){
      //INICIALIZAR PELADAS
      arr.add(eventService.generateEvent(i));
    });
    //RETORNAR ARRAY DE EVENTOS
    return arr;
  }

  //FUNÇÃO PARA SIMULAR BUSCA DE PELADAS MAIS POPULARES
  Future<void>fecthPopular() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(const Duration(seconds: 2));
  }
  
  //FUNÇÃO PARA SIMULAR BUSCA DE TOP PELADAS
  Future<void>fecthTopRanking() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(const Duration(seconds: 2));
    //INICIALIZAR TOP RANKING
  }
  
  //FUNÇÃO PARA SIMULAR BUSCA DE ULTIMOS JOGOS DO USUARIO
  Future<void>fecthUltimosJogos() async {
    //DELAY DE 2 SEGUNDOS
    await Future.delayed(const Duration(seconds: 2));
    
  }
}