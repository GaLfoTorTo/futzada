// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/result_model.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/participant_model.dart';

class GameModel {
  final int id;
  final int? number;
  final EventModel? event;
  final ParticipantModel? referee;
  final int? duration;
  final String? startTime;
  final String? endTime;
  final GameStatus? status;
  final ResultModel? result;
  final List<TeamModel>? teams;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  GameModel({
    required this.id,
    this.number,
    this.event,
    this.referee,
    this.duration,
    this.startTime,
    this.endTime,
    this.status,
    this.result,
    this.teams,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  GameModel copyWith({
    int? id,
    int? number,
    EventModel? event,
    ParticipantModel? referee,
    int? duration,
    String? startTime,
    String? endTime,
    GameStatus? status,
    ResultModel? result,
    List<TeamModel>? teams,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return GameModel(
      id: id ?? this.id,
      number: number ?? this.number,
      event: event ?? this.event,
      referee: referee ?? this.referee,
      duration: duration ?? this.duration,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      result: result ?? this.result,
      teams: teams ?? this.teams,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'event': event?.toMap(),
      'referee': referee?.toMap(),
      'duration': duration,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'result': result?.toMap(),
      'teams': teams != null && teams!.isNotEmpty ? teams!.map((x) => x.toMap()).toList() : [],
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      id: map['id'] as int,
      number: map['number'] != null ? map['number'] as int : null,
      event: map['event'] != null ? EventModel.fromMap(map['event'] as Map<String,dynamic>) : null,
      referee: map['referee'] != null ? ParticipantModel.fromMap(map['referee'] as Map<String,dynamic>) : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      status: map['status'] != null
        ? GameStatus.values.firstWhere((e) => e == map['status'])
        : null,
      result: map['result'] != null 
        ? ResultModel.fromMap(map['result'] as Map<String,dynamic>) 
        : null,
      teams: map['teams'] != null 
        ? List<TeamModel>.from(
            (map['teams'] as List<dynamic>).map<TeamModel?>(
              (x) => TeamModel.fromMap(x as Map<String,dynamic>),
            ),
          ) 
        : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(String source) => GameModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameModel(id: $id, number: $number, event: $event, referee: $referee, duration: $duration, startTime: $startTime, endTime: $endTime, status: $status, result: $result, teams: $teams, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant GameModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.number == number &&
      other.event == event &&
      other.referee == referee &&
      other.duration == duration &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.status == status &&
      other.result == result &&
      listEquals(other.teams, teams) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      number.hashCode ^
      event.hashCode ^
      referee.hashCode ^
      duration.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      status.hashCode ^
      result.hashCode ^
      teams.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
