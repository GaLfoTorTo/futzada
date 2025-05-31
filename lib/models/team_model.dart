// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/participant_model.dart';

class TeamModel {
  final int id;
  final String uuid;
  final String? name;
  final List<ParticipantModel> players;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  TeamModel({
    required this.id,
    required this.uuid,
    this.name,
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
    List<ParticipantModel>? players,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return TeamModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
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
      'players': players.map((x) => x.toMap()).toList(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory TeamModel.fromMap(Map<String, dynamic> map) {
    return TeamModel(
      id: map['id'] as int,
      uuid: map['uuid'] as String,
      name: map['name'] != null ? map['name'] as String : null,
      players: List<ParticipantModel>.from((map['players'] as List<int>).map<ParticipantModel>((x) => ParticipantModel.fromMap(x as Map<String,dynamic>),),),
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeamModel.fromJson(String source) => TeamModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TeamModel(id: $id, uuid: $uuid, name: $name, players: $players, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant TeamModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uuid == uuid &&
      other.name == name &&
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
      players.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
