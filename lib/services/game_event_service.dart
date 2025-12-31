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
  GameEvent setGameEvent(i){
    return GameEvent.values[i];
  }

  Map<String, dynamic> getActionGameEvent(event){
    switch (event) {
      case GameEvent.StartGame:
        return {
          'icon' : Icons.timer_rounded,
          'title' : 'Ínicio da Partida'
        };
      case GameEvent.EndGame:
        return {
          'icon' : Icons.timer_off_rounded,
          'title' : 'Fim da Partida'
        };
      case GameEvent.HalfTimeEnd:
        return {
          'icon' : Icons.timer_off_rounded,
          'title' : 'Intervalo'
        };
      case GameEvent.ExtraTime:
        return {
          'icon' : Icons.timer_rounded,
          'title' : 'Acréssimos'
        };
      case GameEvent.ExtraTimeStart:
        return {
          'icon' : Icons.timer_rounded,
          'title' : 'Ínicio da prorrogação'
        };
      case GameEvent.ExtraTimeEnd:
        return {
          'icon' : Icons.timer_off_rounded,
          'title' : 'Fim da Prorrogação'
        };
      case GameEvent.Penalties:
        return {
          'icon' : Icons.sports,
          'title' : 'Penalties'
        };
      case GameEvent.Goal:
        return {
          'icon' : Icons.sports_soccer_rounded,
          'title' : 'GOOOOOL'
        };
      case GameEvent.Defense:
        return {
          'icon' : Icons.security_rounded,
          'title' : 'Defesa'
        };
      case GameEvent.Penalty:
        return {
          'icon' : Icons.sports,
          'title' : 'Penalti'
        };
      case GameEvent.Corner:
        return {
          'icon' : Icons.flag,
          'title' : 'Escanteio'
        };
      case GameEvent.FreeKick:
        return {
          'icon' : Icons.settings_input_component_rounded,
          'title' : 'Cobrança de Falta'
        };
      case GameEvent.GoalKick:
        return {
          'icon' : Icons.sports_kabaddi_rounded,
          'title' : 'Tiro de Meta'
        };
      case GameEvent.Offside:
        return {
          'icon' : Icons.shuffle_rounded,
          'title' : 'Impedimento'
        };
      case GameEvent.Foul:
      case GameEvent.FoulTaken:
        return {
          'icon' : Icons.sports_kabaddi_outlined,
          'title' : 'Falta'
        };
      case GameEvent.YellowCard:
        return {
          'icon' : Icons.square,
          'title' : 'Cartão Amarelo'
        };
      case GameEvent.RedCard:
        return {
          'icon' : Icons.square,
          'title' : 'Expulsão'
        };
      case GameEvent.Substitution:
        return {
          'icon' : Icons.social_distance_rounded,
          'title' : 'Substituição'
        };
      case GameEvent.Assist:
        return {
          'icon' : Icons.handshake,
          'title' : 'Assistência'
        };
      case GameEvent.Interception:
        return {
          'icon' : Icons.sports_kabaddi_rounded,
          'title' : 'Interceptação'
        };
      case GameEvent.GoalkeeperSave:
        return {
          'icon' : Icons.sports_handball,
          'title' : 'Defesa do Goleiro'
        };
      case GameEvent.Injury:
        return {
          'icon' : Icons.personal_injury_rounded,
          'title' : 'Lesão'
        };
      case GameEvent.VARCheck:
        return {
          'icon' : Icons.desktop_windows,
          'title' : 'VAR'
        };
      default:
        return {
          'icon' : Icons.sports_soccer_rounded,
          'title' : 'Gol'
        };
    }
  }
}