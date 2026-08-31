import 'dart:math';
import 'package:faker/faker.dart';
import 'package:esportly/core/enum/enums.dart';
import 'package:esportly/data/services/rating_service.dart';
import 'package:esportly/data/models/player_model.dart';
import 'package:esportly/data/models/position_model.dart';

class PlayerService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //INTANCIAR SERVICO DE RATING (PONTUAÇÃO)
  RatingService ratingService = RatingService();

  //FUNÇÃO DE GERAÇÃO DE JOGADOR
  PlayerModel generatePlayer(int i){
    final List<PositionModel> positions = [];
    for (final modality in ["Football", "Volleyball", "Basketball"]) {
      final mainAlias = randomPosition(modality, random.nextInt(5));
      final mod = _modalityFromString(modality);
      positions.add(PositionModel(
        id: random.nextInt(100),
        title: mainAlias,
        alias: mainAlias,
        modality: mod,
        main: true,
      ));
      final extras = List.generate(random.nextInt(3), (_) => randomPosition(modality, random.nextInt(5)));
      for (final alias in extras) {
        if (alias == mainAlias) continue;
        positions.add(PositionModel(
          id: random.nextInt(100),
          title: alias,
          alias: alias,
          modality: mod,
          main: false,
        ));
      }
    }
    return PlayerModel(
      id: random.nextInt(100),
      bestSide: random.nextBool() ? 'Right' : 'Left',
      type: faker.lorem.sentence().toString(),
      number: random.nextInt(99),
      positions: positions,
    );
  }

  static Modality _modalityFromString(String modality) {
    switch (modality) {
      case "Volleyball": return Modality.Volleyball;
      case "Basketball": return Modality.Basketball;
      default: return Modality.Football;
    }
  }

  //FUNÇÃO PARA GERAR JOGADORES PARA MERCADO (TEMPORARIAMENTE)
  List<PlayerModel> getPlayers() {
    //JUNTAR MAPS
    final List<PlayerModel> arr = [];
    //GERAR LISTA DE JOGADORES
    List.generate(random.nextInt(100), (i){
      //ADICIONAR JOGADOR A LISTA
      arr.add(
        generatePlayer(i)
      );
    });
    return arr;
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
          return 'ATA';
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