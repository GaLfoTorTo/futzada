import 'dart:math';
import 'package:get/get.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/escalation_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:intl/intl.dart';

class EscalationService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();

  //FUNÇÃO DE GERAÇÃO DE ESCALAÇÃO DO USUARIO
  EscalationModel generateEscalation(String category, List<ParticipantModel> participants){
    //RESGATAR LISTA DE FORMAÇÕES
    List<String> listFormations = getFormations(category);
    //DEFINIR ESCALAÇÃO
    return EscalationModel.fromMap({
      "id" : random.nextInt(2),
      "formation" : listFormations[random.nextInt(listFormations.length)],
      "starters" : setEscalation(category, 'starters'),
      "reserves" : setEscalation(category, 'reserves'),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(faker.date.dateTime(minYear: 2024, maxYear: 2025).toString()),
    });
  }

  //FUNÇÃO PARA CONVERTER ESCALAÇÃO EM RXMAP
  RxMap<int, ParticipantModel?> convertToRxMap(
    Map<int, ParticipantModel?> escalation,
  ) {
    return escalation.obs;
  }
  
  Map<int, ParticipantModel?> convertToMap(
    RxMap<int, ParticipantModel?> escalation,
  ) {
    return Map<int, ParticipantModel?>.from(escalation);
  }

  //FUNÇÃO PARA INICIALIZAR ESCALAÇÃO COM VALORES NULOS
  RxMap<int, ParticipantModel?> setEscalation(String category, String occupation) {
    //CRIAR MAPS DE TITULARES E RESERVAS OBSERVAVEIS
    final starters = <int, ParticipantModel?>{}.obs;
    final reserves = <int, ParticipantModel?>{}.obs;
    //VARIAVEL DE CONTROLE DE QUANTIDADE DE JOGADORES POR CATEGORIA
    int num;
    int numRes;
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
        num = 11;
        numRes = 5;
        break;
    }
    //INICIALIZAR COM VALORES NULOS
    for (var i = 0; i < num; i++) {
      starters[i] = null;
    }
    for (var i = 0; i < numRes; i++) {
      reserves[i] = null;
    }
    //RETORNAR ESCALAÇÃO
    if(occupation == 'starters'){
      return starters;
    }else{
      return reserves;
    }
  }

  //FUNÇÃO PARA DEFINIR OS TIPOS DE FORMAÇÃO DEPENDENDO DA CATEGORIA DA PELADA
  List<String> getFormations(String category){
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
          '3-1-2',
          '3-2-1',
          '3-0-3',
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

  //FUNÇÃO PARE DEFINIR NOME DE POSIÇÃO
  String getPositionName(int index, String category, List<int> positions) {
    //DEFINIR NOME DA POSIÇÃO PADRÃO
    String description = 'Jogador';
    //PERCORRER POSIÇÕES DA FORMAÇÃO
    positions.asMap().entries.map((entry) {
      //RESGATAR SETOR DA FORMAÇÃO
      final groupPosition = entry.key;
      //BUSCAR QUANTIDADE DE JOGADORES NO SETOR
      final qtd = entry.value;
      //INVERTER SETORES
      final invertedGroupPos = positions.length - 1 - groupPosition;
      //BUSCAR INDEX DA POSIÇÃO NO SETOR
      final groupStartIndex = positions
          .reversed
          .toList()
          .sublist(0, invertedGroupPos)
          .fold(0, (sum, item) => sum + item);
      //RESGATAR QUANTIDADE DE LINHAS NA FORMAÇÃO 
      final linhas = positions.length;
      //VERIFICAR CATEGORIA E DEFINIR NOME DA POSIÇÃO
      switch (category) {
        case 'Futebol':
          //SE FOR FUTEBOL, CHAMAR FUNÇÃO DE POSIÇÃO DE FUTEBOL
          description = getFootballPosition(invertedGroupPos, linhas);
          break;
        case 'Fut7':
          //SE FOR FUT7, CHAMAR FUNÇÃO DE POSIÇÃO DE FUT7
          description = getFut7Position(invertedGroupPos, linhas);
          break;
        case 'Futsal':
          //SE FOR FUTSAL, CHAMAR FUNÇÃO DE POSIÇÃO DE FUTSAL
          description = getFutsalPosition(invertedGroupPos, linhas);
          break;
        default:
          description = getFootballPosition(invertedGroupPos, linhas);
      }
    });
    //RETORNAR NOME DA POSIÇÃO
    return description;
  }

  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUTEBOL
  String getFootballPosition(int index, int linhas) {
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    if(linhas == 4){
      //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
      switch (index) {
        case 0:
          return 'Goleiro';
        case 1:
          return 'Zagueiro';
        case 2:
          return 'Meio-Campo';
        case 3:
          return 'Atacante';
        default:
          return 'Jogador';
      }
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    }else if(linhas == 5){
      //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
      switch (index) {
        case 0:
          return 'Goleiro';
        case 1:
          return 'Zagueiro';
        case 2:
        case 3:
          return 'Meio-Campo';
        case 4:
          return 'Atacante';
        default:
          return 'Jogador';
      }
    }
    return 'Jogador';
  }
  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUT7
  String getFut7Position(int index, int players) {
    switch (index) {
      case 0:
        return 'Goleiro';
      case 1:
        return 'Zagueiros';
      case 2:
        return 'Meio-Campo';
      case 3:
        return 'Atacante';
      case 4:
        return 'Atacante';
      default:
        return 'Jogador';
    }
  }
  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUTSAL
  String getFutsalPosition(int index, int players) {
    switch (index) {
      case 0:
        return 'Goleiro';
      case 1:
        return 'Fixo';
      case 2:
        return 'Meio-campo';
      case 3:
        if (players == 2) return 'Ala';
        if (players == 1) return 'Pivô';
        return 'Ala';
      default:
        return 'Jogador';
    }
  }

  //FUNÇÃO QUE DEFINE A FORMAÇÃO NA AMOSTRAGEM DO CAMPO APARTIR DA QUANTIDADE DE JOGADORES DEFINA
  List<int> setFormation(qtd){
    switch (qtd) {
      case 4:
        //SETORES PARA 4 JOGADORES
        return [0, 2, 1];
      case 5:
        //SETORES PARA 5 JOGADORES
        return [1, 2, 1];
      case 6:
        //SETORES PARA 6 JOGADORES
        return [1, 2, 2];
      case 7:
        //SETORES PARA 7 JOGADORES
        return [1, 3, 2];
      case 8:
        //SETORES PARA 8 JOGADORES
        return [2, 3, 2];
      case 9:
        //SETORES PARA 9 JOGADORES
        return [2, 3, 3];
      case 10:
        //SETORES PARA 10 JOGADORES
        return [3, 3, 3];
      case 11:
        //SETORES PARA 11 JOGADORES
        return [3, 4, 4];
      default:
        return [3, 4, 4];
    }
  }
}