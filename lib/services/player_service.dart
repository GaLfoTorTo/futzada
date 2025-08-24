import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:faker/faker.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/services/rating_service.dart';
import 'package:futzada/models/player_model.dart';
import 'package:intl/intl.dart';

class PlayerService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  RatingService ratingService = RatingService();

  //FUNÇÃO DE GERAÇÃO DE JOGADOR
  PlayerModel generatePlayer(i){
    //DADOS DO JOGADOR
    var num = random.nextInt(11);

    //DEFINIR PLAYER
    return PlayerModel.fromMap({
      'id': i,
      'bestSide': random.nextBool() ? 'Right' : 'Left',
      'type': faker.lorem.sentence().toString(),
      'mainPosition': getPositionFromEscalation(num),
      'positions' : jsonEncode(setPositions()),
      "rating" : ratingService.generateRating(Roles.Player).toMap(),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA GERAR JOGADORES PARA MERCADO (TEMPORARIAMENTE)
  RxList<PlayerModel> getPlayers() {
    //JUNTAR MAPS
    final List<PlayerModel> arr = [];
    //GERAR LISTA DE JOGADORES
    List.generate(random.nextInt(100), (i){
      //ADICIONAR JOGADOR A LISTA
      arr.add(
        generatePlayer(i)
      );
    });
    return arr.obs;
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
  String getPositionFromEscalation(i){
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