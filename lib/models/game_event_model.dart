// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/result_model.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/participant_model.dart';

class GameEventModel {
  final int id;
  final TeamModel team;
  final ParticipantModel? participant;
  final int? minute;
  final String? title;
  final String? description;
  final GameEvent? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  GameEventModel({
    required this.id,
    required this.team,
    required this.participant,
    this.minute,
    this.title,
    this.description,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  GameEventModel copyWith({
    int? id,
    TeamModel? team,
    ParticipantModel? participant,
    int? minute,
    String? title,
    String? description,
    GameEvent? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return GameEventModel(
      id: id ?? this.id,
      participant: participant ?? this.participant,
      team: team ?? this.team,
      minute: minute ?? this.minute,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'team' : team,
      'participant': participant?.toMap(),
      'minute' : minute,
      'title' : title,
      'description' : description,
      'type' : type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory GameEventModel.fromMap(Map<String, dynamic> map) {
    return GameEventModel(
      id: map['id'] as int,
      team: TeamModel.fromMap(map['team'] as Map<String,dynamic>),
      participant: ParticipantModel.fromMap(map['participant'] as Map<String,dynamic>),
      minute: map['minute'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      type: map['type'] as GameEvent,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameEventModel.fromJson(String source) => GameEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameEventModel(id: $id, team: $team, participant: $participant, minute: $minute, title: $title, description: $description, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant GameEventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.team == team && 
      other.participant == participant &&
      other.minute == minute && 
      other.title == title && 
      other.description == description && 
      other.type == type && 
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      team.hashCode ^
      participant.hashCode ^
      minute.hashCode ^
      title.hashCode ^
      description.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
