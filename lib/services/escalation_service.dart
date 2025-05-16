import 'package:futzada/models/player_model.dart';
import 'package:get/get.dart';

class EscalationService {

  //FUNÇÃO PARA INICIALIZAR ESCALAÇÃO COM VALORES NULOS
  RxMap<String, RxMap<int, PlayerModel?>> setEscalation(String category) {
    //CRIAR MAPS DE TITULARES E RESERVAS OBSERVAVEIS
    final starters = <int, PlayerModel?>{}.obs;
    final reserves = <int, PlayerModel?>{}.obs;
    //VARIAVEL DE CONTROLE DE QUANTIDADE DE JOGADORES POR CATEGORIA
    int num = 11;
    int numRes = 5;
    switch (category) {
      case 'Futebol':
        num = 11;
        numRes = 5;
        break;
      case 'Fut7':
        num = 9;
        numRes = 3;
      case 'Futsal':
        num = 6;
        numRes = 2;
        break;
      default:
    }
    //INICIALIZAR COM VALORES NULOS
    for (var i = 0; i < num; i++) {
      starters[i] = null;
    }
    for (var i = 0; i < numRes; i++) {
      reserves[i] = null;
    }
    //RETORNAR ESCALAÇÃO
    return <String, RxMap<int, PlayerModel?>>{
      'starters': starters,
      'reserves': reserves,
    }.obs;
  }

  //FUNÇÃO PARA DEFINIR OS TIPOS DE FORMAÇÃO DEPENDENDO DA CATEGORIA DA PELADA
  List<String> formationsPerCategory(String category){
    switch (category) {
      case 'Futebol':
        return [
          '4-3-3',
          '4-1-2-3',
          '4-2-1-3',
          '4-2-3-1',
          '4-4-2',
          '3-4-3',
          '3-2-4-1',
          '3-4-2-1',
          '5-3-2',
          '5-4-1'
        ];
      case 'Fut7':
        return [
          '3-0-3',
          '3-2-1',
          '3-1-2',
          '2-1-3',
          '2-1-2-1',
          '2-2-2',
          '2-3-1',
          '1-4-1',
          '1-3-2',
          '1-2-3',
        ];
      case 'Futsal':
        return [
          '2-0-2',
          '2-1-1',
          '1-2-1',
          '1-3',
          '1-1-2',
        ];
      default:
        return [
          '4-3-3',
          '4-1-2-3',
          '4-2-1-3',
          '4-2-3-1',
          '4-4-2',
          '3-4-3',
          '3-2-4-1',
          '3-4-2-1',
          '5-3-2',
          '5-4-1'
        ];
    }
  }
}