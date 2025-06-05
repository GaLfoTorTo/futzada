// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/models/team_model.dart';

class ResultModel {
  final TeamModel teamA;
  final TeamModel teamB;
  final int teamAScore;
  final int teamBScore;
  final int? duration;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ResultModel({
    required this.teamA,
    required this.teamB,
    required this.teamAScore,
    required this.teamBScore,
    required this.duration,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ResultModel copyWith({
    TeamModel? teamA,
    TeamModel? teamB,
    int? teamAScore,
    int? teamBScore,
    int? duration,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ResultModel(
      teamA: teamA ?? this.teamA,
      teamB: teamB ?? this.teamB,
      teamAScore: teamAScore ?? this.teamAScore,
      teamBScore: teamBScore ?? this.teamBScore,
      duration: duration ?? this.duration,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'teamA': teamA.toMap(),
      'teamB': teamB.toMap(),
      'teamAScore': teamAScore,
      'teamBScore': teamBScore,
      'duration': duration,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory ResultModel.fromMap(Map<String, dynamic> map) {
    return ResultModel(
      teamA: TeamModel.fromMap(map['teamA'] as Map<String,dynamic>),
      teamB: TeamModel.fromMap(map['teamB'] as Map<String,dynamic>),
      teamAScore: map['teamAScore'] as int,
      teamBScore: map['teamBScore'] as int,
      duration: map['duration'] != null ? map['duration'] as int : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ResultModel.fromJson(String source) => ResultModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ResultModel(teamA: $teamA, teamB: $teamB, teamAScore: $teamAScore, teamBScore: $teamBScore, duration: $duration, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant ResultModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.teamA == teamA &&
      other.teamB == teamB &&
      other.teamAScore == teamAScore &&
      other.teamBScore == teamBScore &&
      other.duration == duration &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return teamA.hashCode ^
      teamB.hashCode ^
      teamAScore.hashCode ^
      teamBScore.hashCode ^
      duration.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
