import 'dart:math';
import 'package:futzada/theme/app_icones.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/models/escalation_model.dart';
import 'package:futzada/models/participant_model.dart';

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
  
  //FUNÇÃO PARA CONVERTER ESCALÇAI EM MAP
  Map<int, ParticipantModel?> convertToMap(
    RxMap<int, ParticipantModel?> escalation,
  ) {
    return Map<int, ParticipantModel?>.from(escalation);
  }

  //FUNÇÃO PARA INICIALIZAR ESCALAÇÃO COM VALORES NULOS
  List<ParticipantModel?> setEscalation(String category, String occupation) {
    //VARIAVEL DE CONTROLE DE QUANTIDADE DE JOGADORES POR CATEGORIA
    int numSta;
    int numRes;
    switch (category) {
      case 'Futebol':
        numSta = 11;
        numRes = 5;
        break;
      case 'Fut7':
        numSta = 9;
        numRes = 3;
      case 'Futsal':
        numSta = 6;
        numRes = 2;
        break;
      default:
        numSta = 11;
        numRes = 5;
        break;
    }
    //RETORNAR ESCALAÇÃO
    if(occupation == 'starters'){
      //INICIALIZAR TITULARES COM VALORES NULOS
      return RxList<ParticipantModel?>.filled(numSta, null);
    } else {
      //INICIALIZAR RESERVAS COM VALORES NULOS
      return RxList<ParticipantModel?>.filled(numRes, null);
    }
  }

  //FUNÇÃO PARE DEFINIR NOME DE POSIÇÃO
  String getPositionName(int sectorIndex, String category, String formationString) {
    //FUNÇÃO DE DEFINIÇÃO DE FORMAÇÃO POR CATEGORIA
    final formation = getFormationList(formationString);
    final totalGroups = formation.length;
    final playersInGroup = formation.toList()[sectorIndex];
    
    switch (category) {
      case 'Futebol':
        return getFootballPosition(sectorIndex, totalGroups, playersInGroup);
      case 'Fut7':
        return getFut7Position(sectorIndex, totalGroups, playersInGroup);
      case 'Futsal':
        return getFutsalPosition(sectorIndex, playersInGroup);
      default:
        return 'Jogador';
    }
  }

  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUTEBOL
  String getFootballPosition(int index, int linhas, int playersInGroup) {
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    if(linhas == 4){
      //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
          return 'Meio-Campo';
        case 2:
          return 'Zagueiro';
        case 3:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    }else if(linhas == 5){
      //VERIFICAR QUANTIDADE DE ZAGUEIROS OU MEIAS
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
        case 2:
          return 'Meio-Campo';
        case 3:
          return 'Zagueiro';
        case 4:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    }
    return 'Jogador';
  }

  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUT7
  String getFut7Position(int index, int linhas, int playersInGroup){
    //VERIFICAR LINHAS DE LINHAS NA FORMAÇÃO
    if(linhas == 5){
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
        case 2:
          return 'Meio-Campo';
        case 3:
          return 'Zagueiros';
        case 4:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    }else{
      switch (index) {
        case 0:
          return 'Atacante';
        case 1:
          return 'Meio-Campo';
        case 2:
          return 'Zagueiros';
        case 3:
          return 'Goleiro';
        default:
          return 'Jogador';
      }
    }
  }
  
  //FUNÇÃO PARA SELECIONAR NOME DA POSIÇÃO PARA FUTSAL
  String getFutsalPosition(int index, int playersInGroup){
    switch (index) {
      case 0:
        if (playersInGroup == 2) return 'Ala';
        if (playersInGroup == 1) return 'Pivô';
        return 'Ala';
      case 1:
        return 'Meio-campo';
      case 2:
        return 'Fixo';
      case 3:
        return 'Goleiro';
      default:
        return 'Jogador';
    }
  }
  
  //FUNÇÃO DE ESTAMPA DO CAMPO
  String fieldType(String? category){
    switch (category) {
      case 'Futebol':
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.futebol_sm;
      case 'Fut7':
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.fut7_sm;
      case 'Futsal':
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.futsal_sm;
      default:
        //DEFINIR LINHAS DE CAMPO
        return AppIcones.futebol_sm;
    }
  }

  //FUNÇÃO DE DEFINIÇÃO DE FORMAÇÃO POR CATEGORIA
  List<int> getFormationList(String formation) {
    List<int> splitedFormation = formation.split('-').map((i) => int.parse(i)).toList();
    splitedFormation.insert(0, 1);
    return splitedFormation.reversed.toList();
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