// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/helpers/date_helper.dart';

class GameEventModel {
  final int id;
  final int gameId;
  final int teamId;
  final int? userId;
  final int? minute;
  final String? title;
  final String? description;
  final GameEvent? type;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  GameEventModel({
    required this.id,
    required this.gameId,
    required this.teamId,
    required this.userId,
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
    int? gameId,
    int? teamId,
    int? userId,
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
      gameId: gameId ?? this.gameId,
      userId: userId ?? this.userId,
      teamId: teamId ?? this.teamId,
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
      'gameId': gameId,
      'teamId' : teamId,
      'userId': userId,
      'minute' : minute,
      'title' : title,
      'description' : description,
      'type' : type,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory GameEventModel.fromMap(Map<String, dynamic> map) {
    return GameEventModel(
      id: map['id'] as int,
      gameId: map['gameId'] as int,
      userId: map['userId'] as int,
      teamId: map['teamId'] as int,
      minute: map['minute'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      type: map['type'] as GameEvent,
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameEventModel.fromJson(String source) => GameEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameEventModel(id: $id, gameId: $gameId, teamId: $teamId, userId: $userId, minute: $minute, title: $title, description: $description, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant GameEventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.gameId == gameId &&
      other.userId == userId &&
      other.teamId == teamId && 
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
    return 
      id.hashCode ^
      gameId.hashCode ^
      userId.hashCode ^
      teamId.hashCode ^
      minute.hashCode ^
      title.hashCode ^
      description.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
