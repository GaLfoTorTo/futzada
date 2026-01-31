// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/helpers/date_helper.dart';

class StatsModel {
  int? gameId;
  List<Map<String, int>>? stats;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  StatsModel({
    required this.gameId,
    this.stats,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  StatsModel copyWith({
    int? gameId,
    int? teamId,
    List<Map<String, int>>? stats,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return StatsModel(
      gameId: gameId ?? this.gameId,
      stats : stats ?? this.stats,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gameId' : gameId,
      'stats' : stats,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      gameId : map['gameId'] as int,
      stats : map['stats'] != null ? map['stats'] as List<Map<String, int>> : null,
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsModel.fromJson(String source) => StatsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatsModel(gameId: $gameId, stats: $stats, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant StatsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.gameId == gameId &&
      other.stats == stats &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      gameId.hashCode ^
      stats.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
