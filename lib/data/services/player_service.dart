import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:faker/faker.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/services/rating_service.dart';
import 'package:futzada/data/models/player_model.dart';

class PlayerService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  RatingService ratingService = RatingService();

  //FUNÇÃO DE GERAÇÃO DE JOGADOR
  PlayerModel generatePlayer(int i){
    //DEFINIR PLAYER
    return PlayerModel.fromMap({
      'id': random.nextInt(100),
      'userId': i,
      'bestSide': random.nextBool() ? 'Right' : 'Left',
      'type': faker.lorem.sentence().toString(),
      'mainPosition': {
        "Football": randomPosition("Football", random.nextInt(5)),
        "Volleyball": randomPosition("Volleyball", random.nextInt(5)),
        "Basketball": randomPosition("Basketball", random.nextInt(5)),
      },
      'positions': {
        "Football": List.generate(random.nextInt(5), (i) => randomPosition("Football", random.nextInt(5))),
        "Volleyball": List.generate(random.nextInt(5), (i) => randomPosition("Volleyball", random.nextInt(5))),
        "Basketball": List.generate(random.nextInt(5), (i) => randomPosition("Basketball", random.nextInt(5))),
      },
      "rating" : null,//ratingService.generateRating(Roles.Player).toMap(),
      "createdAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
      "updatedAt" : faker.date.dateTime(minYear: 2024, maxYear: 2025),
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
      positions.add(randomPosition(randomModality(), num)); 
    } 
    //REMOVER DUPLICATAS
    positions = positions.toSet().toList();
    return positions;
  }

  static String randomModality(){
    switch (random.nextInt(2)) {
      case 0:
        return "Volleyball";
      case 1:
        return "Basketball";
      default:
        return "Football";
    }
  }

  //FUNÇÃO DE CLASSIFICAÇÃO DE POSIÇÕES RANDOMICAS (TEMPORARIAMENTE)
  static String randomPosition(String modality, int i){
    if(modality == "Football"){
      switch (i) {
        case 0:
          return 'GOL';
        case 1:
          return 'ZAG';
        case 2:
          return 'LAT';
        case 3:
          return 'MEI';
        case 4:
          return 'ATA';
        default:
          return 'ata';
      }
    }
    if(modality == "Volleyball"){
      switch (i) {
        case 0:
          return 'LEV';
        case 1:
          return 'OPO';
        case 2:
          return 'PON';
        case 3:
          return 'LIB';
        case 4:
          return 'CEN';
        default:
          return 'LEV';
      }
    }
    if(modality == "Basketball"){
      switch (i) {
        case 0:
          return 'ARM';
        case 1:
          return 'ALA';
        case 2:
          return 'ALM';
        case 3:
          return 'ALP';
        case 4:
          return 'PIV';
        default:
          return 'ARM';
      }
    }
    return "ATA";
  }
}