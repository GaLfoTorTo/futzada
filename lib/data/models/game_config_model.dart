// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:futzada/core/utils/date_utils.dart';

class GameConfigModel {
  int? id;
  int eventId;
  String category;
  int? duration;
  int? playersPerTeam; 
  Map<String, dynamic>? config;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  GameConfigModel({
    this.id,
    required this.eventId,
    required this.category,
    this.duration,
    this.playersPerTeam,
    this.config,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  GameConfigModel copyWith({
    int? id,
    int? eventId,
    String? category,
    int? duration,
    int? playersPerTeam, 
    Map<String, dynamic>? config,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return GameConfigModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      playersPerTeam: playersPerTeam ?? this.playersPerTeam,
      config: config ?? this.config,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'category': category,
      'duration': duration,
      'playersPerTeam': playersPerTeam,
      'config': config,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt,
    };
  }

  factory GameConfigModel.fromMap(Map<String, dynamic> map) {
    return GameConfigModel(
      id: map['id'] as int,
      eventId: map['eventId'] as int,
      category: map['category'] as String,
      duration: map['duration'] != null ? map['duration'] as int : null,
      playersPerTeam: map['playersPerTeam'] != null ? map['playersPerTeam'] as int : null,
      config: map['config'] != null ? map['config'] as Map<String, dynamic> : null,
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt: DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt: DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory GameConfigModel.fromJson(String source) => GameConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameConfigModel(id: $id, eventId: $eventId, category: $category, duration: $duration, playersPerTeam: $playersPerTeam, config: $config, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant GameConfigModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventId == eventId &&
      other.category == category &&
      other.duration == duration &&
      other.playersPerTeam == playersPerTeam &&
      other.config == config &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      eventId.hashCode ^
      category.hashCode ^
      duration.hashCode ^
      playersPerTeam.hashCode ^
      config.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
