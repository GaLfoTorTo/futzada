import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:futzada/models/player_model.dart';
import 'package:faker/faker.dart';

class PlayerService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //JOGADORES NO MERCADO
  final RxList<PlayerModel> playersMarket = setPlayers();
  
  PlayerModel? findPlayer(dynamic id) {
    return playersMarket.firstWhereOrNull((player) => player.id == id);
  }

  //FUNÇÃO PARA GERAR JOGADORES PARA MERCADO (TEMPORARIAMENTE)
  static RxList<PlayerModel> setPlayers() {
    //JUNTAR MAPS
    final List<PlayerModel> map = [];
    //LOOP PARA TITULARES
    for (var i = 1; i <= 50; i++) {
      //DADOS DO JOGADOR
      var firstName = faker.person.firstName();
      var lastName = faker.person.lastName();
      var num = random.nextInt(11);
      var numStatus = random.nextInt(3);
      var bestSide = random.nextBool();
      var type = faker.lorem.toString();

      //DEFINIR PLAYER
      PlayerModel player = PlayerModel.fromMap({
        'id': i,
        'user': {
          'firstName': firstName,
          'lastName': lastName,
          'userName': "${firstName}_${lastName}",
        },
        'bestSide': bestSide ? 'Right' : 'Left',
        'type': type,
        'mainPosition': getPositionFromEscalation(num),
        'positions' : jsonEncode(setPositions()),
        'currentPontuation': 0.0,
        'lastPontuation': double.parse(setValues(5.5, 30.5).toStringAsFixed(2)),
        'media': double.parse(setValues(0.0, 10.0).toStringAsFixed(2)),
        'price': double.parse(setValues(0.0, 30.5).toStringAsFixed(2)),
        'valorization': double.parse(setValues(-5.5, 5.5).toStringAsFixed(2)),
        'games': random.nextInt(50),
        'photo': null,
        'status': setStatus(numStatus),
      });
      //ADICIONAR JOGADOR A LISTA
      map.add(player);
    }
    return map.obs;
  }

  //FUNÇÃO PARA GERAÇÃO DE VALORES (TEMPORARIAMENTE)
  static double setValues(double min, double max){
    return min + random.nextDouble() * (max - min);
  }

  //FUNÇÃO PARA GERAR STATUS DINAMICAMENTE (TEMPORARIAMENTE)
  static String setStatus(i){
    switch (i) {
      case 0:
        return 'Inativo';
      case 1:
        return 'Ativo';
      case 2:
        return 'Duvida';
      case 3:
        return 'Neutro';
      default:
        return 'Neutro';
    }
  }

  //FUNÇÃO PARA DEFINIR POSIÇÕES DO JOGADOR (TEMPORARIAMENTE)
  static List<String> setPositions(){
    List<String> positions = [];
    int qtd = random.nextInt(4);
    for (var i = 0; i < qtd; i++) {
      var num = random.nextInt(4);
      positions.add(randomPosition(num)); 
    } 
    //REMOVER DUPLICATAS
    positions = positions.toSet().toList();
    return positions;
  }

  //FUNÇÃO DE CLASSIFICAÇÃO DE POSIÇÕES RANDOMICAS (TEMPORARIAMENTE)
  static String randomPosition(i){
    switch (i) {
      case 0:
        return 'gol';
      case 1:
        return 'zag';
      case 2:
        return 'mei';
      case 3:
        return 'ata';
      default:
        return 'ata';
    }
  }
  
  //FUNÇÃO PARA DEFINIR POSIÇÃO DINAMICAMENTE (TEMPORARIAMENTE)
  static String getPositionFromEscalation(i){
    if(i == 0){
      return 'gol';
    }else if(i ==  1 || i ==  2 || i == 3 || i == 4){
      return 'zag';
    }else if(i ==  5 || i == 6 || i == 7){
      return 'mei';
    }else{
      return 'ata';
    }
  }
}