// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/utils/date_utils.dart';

class TeamModel {
  final int? id;
  final String? uuid;
  final String? name;
  final String? emblema;
  final List<ParticipantModel> players;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  TeamModel({
    this.id,
    this.uuid,
    this.name,
    this.emblema,
    required this.players,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  TeamModel copyWith({
    int? id,
    String? uuid,
    EventModel? event,
    String? name,
    String? emblema,
    List<ParticipantModel>? players,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return TeamModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      emblema: emblema ?? this.emblema,
      players: players ?? this.players,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'name': name,
      'emblema': emblema,
      'players': players.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt,
    };
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['id'] as int,
      uuid: map['uuid'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      emblema: map['emblema'] != null ? map['emblema'] as String : null,
      players: map['players'] != null
        ? List<ParticipantModel>.from((map['players'] as List<Map<String, dynamic>>)
          .map<ParticipantModel>(
            (x) => ParticipantModel.fromMap(x),
          ),
        )
        : [],
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt: DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt: DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamModel.fromJson(String source) => TeamModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TeamModel(id: $id, uuid: $uuid, name: $name, emblema: $emblema, players: $players, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant TeamModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uuid == uuid &&
      other.name == name &&
      other.emblema == emblema &&
      listEquals(other.players, players) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uuid.hashCode ^
      name.hashCode ^
      emblema.hashCode ^
      players.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
