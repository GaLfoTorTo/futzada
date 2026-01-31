import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';

class EventHelper {
  //FUNÇÃO PARA RESGATAR NOME COMPLETO DO USUARIO
  static UserModel? getUserEvent(EventModel event,int userId){
    return event.participants?.firstWhere((u) => u.id == userId);
  }

  //FUNÇÃO PARA RESGATAR ORGANIZADOR DO EVENTO

  static UserModel getUserOrganizator(EventModel event){
    return event.participants!.firstWhere((u){
      final participant = u.participants!.where((p) => p.eventId == event.id).first;
      return participant.role!.contains("Organizator");
    });
  }
  
  //FUNÇÃO PARA RESGATAR JOGADOR DO EVENTO
  static UserModel getUserPlayer(EventModel event, int userId){
    return event.participants!.firstWhere((u){
      final participant = u.participants!.where((p) => p.eventId == event.id).first;
      return participant.role!.contains("Player");
    });
  }
  
  //FUNÇÃO PARA RESGATAR MANAGERS DO EVENTO
  static UserModel getUserManager(EventModel event){
    return event.participants!.firstWhere((u){
      final participant = u.participants!.where((p) => p.eventId == event.id).first;
      return participant.role!.contains("Manager");
    });
  }

  //FUNÇÃO DE DEFINIÇÃO DE DEFINIÇÕES DE PARTIDA PARA O EVENTO
  static List<Map<String, dynamic>> getInfoGameConfig(EventModel event){
    switch (event.modality!.name) {
      case "Volleyball":
        return [
          {
            'label': "Jogadores por Equipe",
            'icon': Icons.people,
            'value' : event.gameConfig!.playersPerTeam.toString(),
          },
          {
            'label': "Sets",
            'icon': Icons.safety_divider_rounded,
            'value' : event.gameConfig!.config!['sets'] != null ? event.gameConfig!.config!['sets'].toString() : '',
          },
          {
            'label': "Limite de Pontos",
            'icon': Icons.scoreboard,
            'value' : event.gameConfig!.points.toString(),
          },
          {
            'label': "Tie Break",
            'icon': Icons.add_alarm_rounded,
            'value' : event.gameConfig!.config!["tieBreakPoints"] != null ? "Sim" : "Não",
          },
          {
            'label': "Pontos no Tie Break",
            'icon': Icons.scoreboard,
            'value' : event.gameConfig!.config!["tieBreakPoints"].toString(),
          },
          {
            'label': "Árbitro",
            'icon': AppIcones.apito,
            'value' : event.gameConfig!.config!["refereerId"] != null ? "Sim" : "Não",
          },
        ];
      case "Basketball":
        return [
          {
            'label': "Jogadores por Equipe",
            'icon': Icons.people,
            'value' : event.gameConfig!.playersPerTeam.toString(),
          },
          {
            'label': "Quarters",
            'icon': Icons.safety_divider_rounded,
            'value' : event.gameConfig!.config!["quarters"].toString(),
          },
          {
            'label': "Duração (min)",
            'icon': AppIcones.stopwatch_solid,
            'value' : event.gameConfig!.duration.toString(),
          },
          {
            'label': "Shot Clock (seg)",
            'icon': Icons.sports_soccer,
            'value' : event.gameConfig!.config!["shotClock"].toString(),
          },
          {
            'label': "Limite de Pontos",
            'icon': Icons.scoreboard,
            'value' : event.gameConfig!.config!["point"] != null ? event.gameConfig!.config!["point"].toString() : "Não",
          },
          {
            'label': "Árbitro",
            'icon': AppIcones.apito,
            'value' : event.gameConfig!.config!["refereerId"] != null ? "Sim" : "Não",
          },
        ];
      default:
        return [
          {
            'label': "Jogadores por Equipe",
            'icon': Icons.people,
            'value' : event.gameConfig!.playersPerTeam.toString(),
          },
          {
            'label': "Duração (min)",
            'icon': AppIcones.stopwatch_solid,
            'value' : event.gameConfig!.duration.toString(),
          },
          {
            'label': "Limite de Gols",
            'icon': Icons.scoreboard,
            'value' : event.gameConfig!.config!["point"].toString(),
          },
          {
            'label': "2 Tempos",
            'icon': Icons.safety_divider_rounded,
            'value' : event.gameConfig!.config!["halves"] != null ? "Sim" : "Não",
          },
          {
            'label': "Pênaltis",
            'icon': Icons.sports_soccer,
            'value' : event.gameConfig!.config!["penalty"] != null ? "Sim" : "Não",
          },
          {
            'label': "Árbitro",
            'icon': AppIcones.apito,
            'value' : event.gameConfig!.config!["refereerId"] != null ? "Sim" : "Não",
          },
        ];
    }
  }
  
  //FUNÇÃO DE DEFINIÇÃO DE DEFINIÇÕES DE PARTIDA PARA O EVENTO
  static List<Map<String, dynamic>> getDetailGame(EventModel event){
    switch (event.modality!.name) {
      case "Volleyball":
        return [
          {
            'label': "Sets",
            'icon': Icons.safety_divider_rounded,
            'value' : event.gameConfig!.duration.toString(),
          },
          {
            'label': "Limite de Pontos",
            'icon': Icons.scoreboard,
            'value' : event.gameConfig!.points != null ? event.gameConfig!.points.toString() : "Não",
          },
          {
            'label': "Jogadores por Equipe",
            'icon': Icons.people,
            'value' : event.gameConfig!.playersPerTeam.toString(),
          },
          {
            'label': "Tie Break",
            'icon': Icons.add_alarm_rounded,
            'value' : event.gameConfig!.config!["tieBreakPoints"] != null ? "Sim" : "Não",
          },
        ];
      case "Basketball":
        return [
          {
            'label': "Quarters",
            'icon': Icons.safety_divider_rounded,
            'value' : event.gameConfig!.config!["quarters"] != null ? event.gameConfig!.config!["quarters"].toString() : "Não",
          },
          {
            'label': "Duração (min)",
            'icon': AppIcones.stopwatch_solid,
            'value' : event.gameConfig!.duration.toString(),
          },
          {
            'label': "Limite de Pontos",
            'icon': Icons.scoreboard,
            'value' : event.gameConfig!.points != null ? event.gameConfig!.points.toString() : "Não",
          },
          {
            'label': "Jogadores por Equipe",
            'icon': Icons.people,
            'value' : event.gameConfig!.playersPerTeam.toString(),
          },
        ];
      default:
        return [
          {
            'label': "2 Tempos",
            'icon': Icons.safety_divider_rounded,
            'value' : event.gameConfig!.config!["halves"] != null ? "Sim" : "Não",
          },
          {
            'label': "Duração (min)",
            'icon': AppIcones.stopwatch_solid,
            'value' : event.gameConfig!.duration.toString(),
          },
          {
            'label': "Limite de Gols",
            'icon': Icons.scoreboard,
            'value' : event.gameConfig!.points != null ? event.gameConfig!.points.toString() : "Não",
          },
          {
            'label': "Jogadores por Equipe",
            'icon': Icons.people,
            'value' : event.gameConfig!.playersPerTeam.toString(),
          },
        ];
    }
  }
}