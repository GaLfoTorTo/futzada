import 'dart:math';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/user_model.dart';

class GameService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  GameModel generateGame(i){
    return GameModel.fromMap({

    });
  }

  //FUNÇÃO PARA BUSCAR PARTIDA SELECIONADO
  GameModel getCurrentGame(){
    //RESGATAR JOGO ATUAL
    return GameModel.fromMap({

    });
  }
  
  //FUNÇÃO PARA GERAR PROXIMAS PARTIDAS
  List<GameModel> getNextGames(){
    //DEFINIR LISTA DE JOGOS
    List<GameModel> games = [];
    //LOOP PARA TITULARES
    List.generate(random.nextInt(5), (i){
      //ADICIONAR JOGO AO LISTA
      games.add(
        generateGame(i)
      );
    });
    //RETORNAR LISTA DE JOGOS
    return games;
  }

  //FUNÇÃO PARA BUSCAR TODOS OS JOGOS DO EVENTO
  List<GameModel> getGames(){
    //DEFINIR LISTA DE JOGOS
    List<GameModel> games = [];
    //LOOP PARA TITULARES
    List.generate(random.nextInt(5), (i){
      //ADICIONAR JOGO AO LISTA
      games.add(
        generateGame(i)
      );
    });
    //RETORNAR LISTA DE JOGOS
    return games;
  }
}