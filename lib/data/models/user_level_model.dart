// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:futzada/data/models/level_model.dart';

class UserLevelModel {
  final int id;
  final int userId;
  final int levelId;
  final int points;
  final LevelModel? level;

  UserLevelModel({
    required this.id,
    required this.userId,
    required this.levelId,
    required this.points,
    this.level,
  });

  UserLevelModel copyWith({
    int? id,
    int? userId,
    int? levelId,
    int? points,
    LevelModel? level,
  }) {
    return UserLevelModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      levelId: levelId ?? this.levelId,
      points: points ?? this.points,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'levelId': levelId,
      'points': points,
      'level': level?.toMap(),
    };
  }

  factory UserLevelModel.fromMap(Map<String, dynamic> map) {
    return UserLevelModel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      levelId: map['levelId'] as int,
      points: map['points'] as int,
      level: map['level'] != null ? LevelModel.fromMap(map['level'] as Map<String, dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLevelModel.fromJson(String source) => UserLevelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserLevelModel(id: $id, userId: $userId, levelId: $levelId, points: $points, level: $level)';
  }

  @override
  bool operator ==(covariant UserLevelModel other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.userId == userId &&
      other.levelId == levelId &&
      other.points == points &&
      other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      levelId.hashCode ^
      points.hashCode ^
      level.hashCode;
  }
}
