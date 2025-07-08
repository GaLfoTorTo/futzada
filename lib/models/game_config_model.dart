// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class GameConfigModel {
  int? id;
  String? category;
  int? duration;
  bool? hasTwoHalves;
  bool? hasExtraTime;
  bool? hasPenalty;
  bool? hasGoalLimit;
  bool? hasRefereer;
  int? playersPerTeam; 
  int? extraTime;
  int? goalLimit;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  GameConfigModel({
    this.id,
    this.category,
    this.duration,
    this.hasTwoHalves,
    this.hasExtraTime,
    this.hasPenalty,
    this.hasGoalLimit,
    this.hasRefereer,
    this.playersPerTeam,
    this.extraTime,
    this.goalLimit,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  GameConfigModel copyWith({
    int? id,
    String? category,
    int? duration,
    bool? hasTwoHalves,
    bool? hasExtraTime,
    bool? hasPenalty,
    bool? hasGoalLimit,
    bool? hasRefereer,
    int? playersPerTeam,
    int? extraTime,
    int? goalLimit,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return GameConfigModel(
      id: id ?? this.id,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      hasTwoHalves: hasTwoHalves ?? this.hasTwoHalves,
      hasExtraTime: hasExtraTime ?? this.hasExtraTime,
      hasPenalty: hasPenalty ?? this.hasPenalty,
      hasGoalLimit: hasGoalLimit ?? this.hasGoalLimit,
      hasRefereer: hasRefereer ?? this.hasRefereer,
      playersPerTeam: playersPerTeam ?? this.playersPerTeam,
      extraTime: extraTime ?? this.extraTime,
      goalLimit: goalLimit ?? this.goalLimit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'duration': duration,
      'hasTwoHalves': hasTwoHalves,
      'hasExtraTime': hasExtraTime,
      'hasPenalty': hasPenalty,
      'hasGoalLimit': hasGoalLimit,
      'hasRefereer': hasRefereer,
      'playersPerTeam': playersPerTeam,
      'extraTime': extraTime,
      'goalLimit': goalLimit,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory GameConfigModel.fromMap(Map<String, dynamic> map) {
    return GameConfigModel(
      id: map['id'] != null ? map['id'] as int : null,
      category: map['category'] != null ? map['category'] as String : null,
      duration: map['duration'] != null ? map['duration'] as int : null,
      hasTwoHalves: map['hasTwoHalves'] != null ? map['hasTwoHalves'] as bool : null,
      hasExtraTime: map['hasExtraTime'] != null ? map['hasExtraTime'] as bool : null,
      hasPenalty: map['hasPenalty'] != null ? map['hasPenalty'] as bool : null,
      hasGoalLimit: map['hasGoalLimit'] != null ? map['hasGoalLimit'] as bool : null,
      hasRefereer: map['hasRefereer'] != null ? map['hasRefereer'] as bool : null,
      playersPerTeam: map['playersPerTeam'] != null ? map['playersPerTeam'] as int : null,
      extraTime: map['extraTime'] != null ? map['extraTime'] as int : null,
      goalLimit: map['goalLimit'] != null ? map['goalLimit'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameConfigModel.fromJson(String source) => GameConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'GameConfigModel(id: $id, category: $category, duration: $duration, hasTwoHalves: $hasTwoHalves, hasExtraTime: $hasExtraTime, hasPenalty: $hasPenalty, hasGoalLimit: $hasGoalLimit, hasRefereer: $hasRefereer, playersPerTeam: $playersPerTeam, extraTime: $extraTime, goalLimit: $goalLimit, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant GameConfigModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.category == category &&
      other.duration == duration &&
      other.hasTwoHalves == hasTwoHalves &&
      other.hasExtraTime == hasExtraTime &&
      other.hasPenalty == hasPenalty &&
      other.hasGoalLimit == hasGoalLimit &&
      other.hasRefereer == hasRefereer &&
      other.playersPerTeam == playersPerTeam &&
      other.extraTime == extraTime &&
      other.goalLimit == goalLimit &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      category.hashCode ^
      duration.hashCode ^
      hasTwoHalves.hashCode ^
      hasExtraTime.hashCode ^
      hasPenalty.hashCode ^
      hasGoalLimit.hashCode ^
      hasRefereer.hashCode ^
      playersPerTeam.hashCode ^
      extraTime.hashCode ^
      goalLimit.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
