import 'dart:math';
import 'package:flutter/material.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:intl/intl.dart';
import 'package:faker/faker.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/game_event_model.dart';

class GameEventService {
  //INSTANCIAR FAKER E RANDOM (TEMPORARIAMENTE)
  static var faker = Faker();
  static var random = Random();
  
  //FUNÇÃO DE GERAÇÃO DE PARTIDA
  GameEventModel generateGameEvent(TeamModel team,  ParticipantModel participant){
    return GameEventModel.fromMap({
      "id" : random.nextInt(100),
      "team" : team.toMap(),
      "participant" : participant.toMap(),
      "minute" : random.nextInt(90),
      "title" : faker.company.name(),
      "description" : faker.lorem.sentence().toString(),
      "type" : setGameEvent(random.nextInt(20)),
      "createdAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(new DateTime.now().toString()),
      "updatedAt" : DateFormat('yyyy-MM-dd HH:mm:ss').parse(new DateTime.now().toString()),
    });
  }

  //FUNÇÃO PARA DEFINIR PERFIS DE PARTICIPANTES DO EVENTO
  GameEventType setGameEvent(i){
    return GameEventType.values[i];
  }

  Map<String, dynamic> getActionGameEvent(event){
    switch (event) {
      case GameEventType.StartGame:
        return {
          'icon' : Icons.timer_rounded,
          'title' : 'Ínicio da Partida'
        };
      case GameEventType.EndGame:
        return {
          'icon' : Icons.timer_off_rounded,
          'title' : 'Fim da Partida'
        };
      case GameEventType.HalfTimeEnd:
        return {
          'icon' : Icons.timer_off_rounded,
          'title' : 'Intervalo'
        };
      case GameEventType.ExtraTime:
        return {
          'icon' : Icons.timer_rounded,
          'title' : 'Acréssimos'
        };
      case GameEventType.ExtraTimeStart:
        return {
          'icon' : Icons.timer_rounded,
          'title' : 'Ínicio da prorrogação'
        };
      case GameEventType.ExtraTimeEnd:
        return {
          'icon' : Icons.timer_off_rounded,
          'title' : 'Fim da Prorrogação'
        };
      case GameEventType.Penalties:
        return {
          'icon' : AppIcones.foot_futebol_solid,
          'title' : 'Penalties'
        };
      case GameEventType.Goal:
        return {
          'icon' : Icons.sports_soccer,
          'title' : 'GOOOOOL'
        };
      case GameEventType.Defense:
        return {
          'icon' : Icons.back_hand,
          'title' : 'Defesa'
        };
      case GameEventType.Penalty:
        return {
          'icon' : AppIcones.foot_futebol_solid,
          'title' : 'Penalti'
        };
      case GameEventType.Corner:
        return {
          'icon' : Icons.flag,
          'title' : 'Escanteio'
        };
      case GameEventType.FreeKick:
        return {
          'icon' : Icons.crisis_alert_rounded,
          'title' : 'Cobrança de Falta'
        };
      case GameEventType.GoalKick:
        return {
          'icon' : Icons.sports_kabaddi_rounded,
          'title' : 'Tiro de Meta'
        };
      case GameEventType.Offside:
        return {
          'icon' : Icons.sports,
          'title' : 'Impedimento'
        };
      case GameEventType.Foul:
        return {
          'icon' : Icons.medical_services,
          'title' : 'Falta'
        };
      case GameEventType.YellowCard:
        return {
          'icon' : Icons.square,
          'title' : 'Cartão Amarelo'
        };
      case GameEventType.RedCard:
        return {
          'icon' : Icons.square,
          'title' : 'Expulso'
        };
      case GameEventType.Substitution:
        return {
          'icon' : Icons.compare_arrows_rounded,
          'title' : 'Substituição'
        };
      case GameEventType.Assist:
        return {
          'icon' : Icons.handshake,
          'title' : 'Assistência'
        };
      case GameEventType.Interception:
        return {
          'icon' : Icons.sports_kabaddi_rounded,
          'title' : 'Interceptação'
        };
      case GameEventType.GoalkeeperSave:
        return {
          'icon' : Icons.sports_handball,
          'title' : 'Defesa do Goleiro'
        };
      case GameEventType.Injury:
        return {
          'icon' : Icons.personal_injury_rounded,
          'title' : 'Lesão'
        };
      case GameEventType.VARCheck:
        return {
          'icon' : Icons.tv,
          'title' : 'VAR'
        };
      default:
        return {
          'icon' : Icons.sports_soccer,
          'title' : 'Gol'
        };
    }
  }
}