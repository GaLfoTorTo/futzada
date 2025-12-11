// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/models/team_model.dart';

class StatsModel {
  final TeamModel team;
  final int? corners;
  final int? fouls;
  final int? defense;
  final int? offset;
  final int? passes;
  final int? possesion;
  final int? shots;
  final int? shotsGoal;
  final int? yellowCard;
  final int? redCard;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  StatsModel({
    required this.team,
    this.corners = 0,
    this.fouls = 0,
    this.defense = 0,
    this.offset = 0,
    this.passes = 0,
    this.possesion = 0,
    this.shots = 0,
    this.shotsGoal = 0,
    this.yellowCard = 0,
    this.redCard = 0,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  StatsModel copyWith({
    TeamModel? team,
    int? corners,
    int? fouls,
    int? defense,
    int? offset,
    int? passes,
    int? possesion,
    int? shots,
    int? shotsGoal,
    int? yellowCard,
    int? redCard,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return StatsModel(
      team: team ?? this.team,
      corners : corners ?? this.corners,
      fouls : fouls ?? this.fouls,
      defense : defense ?? this.defense,
      offset : offset ?? this.offset,
      passes : passes ?? this.passes,
      possesion : possesion ?? this.possesion,
      shots : shots ?? this.shots,
      shotsGoal : shotsGoal ?? this.shotsGoal,
      yellowCard : yellowCard ?? this.yellowCard,
      redCard : redCard ?? this.redCard,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'team': team.toMap(),
      'corners' : corners,
      'fouls' : fouls,
      'defense' : defense,
      'offset' : offset,
      'passes' : passes,
      'possesion' : possesion,
      'shots' : shots,
      'shotsGoal' : shotsGoal,
      'yellowCard' : yellowCard,
      'redCard' : redCard,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      team: TeamModel.fromMap(map['team'] as Map<String,dynamic>),
      corners : map['corners'] as int,
      fouls : map['fouls'] as int,
      defense : map['defense'] as int,
      offset : map['offset'] as int,
      passes : map['passes'] as int,
      possesion : map['possesion'] as int,
      shots : map['shots'] as int,
      shotsGoal : map['shotsGoal'] as int,
      yellowCard : map['yellowCard'] as int,
      redCard : map['redCard'] as int,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatsModel.fromJson(String source) => StatsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatsModel(team: $team, corners: $corners, fouls: $fouls, defense: $defense, offset: $offset, passes: $passes, possesion: $possesion, shots: $shots, shotsGoal, $shotsGoal, yellowCard: $yellowCard, redCard: $redCard, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant StatsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.team == team &&
      other.corners == corners &&
      other.fouls == fouls &&
      other.defense == defense &&
      other.offset == offset &&
      other.passes == passes &&
      other.possesion == possesion &&
      other.shots == shots &&
      other.shotsGoal == shotsGoal &&
      other.yellowCard == yellowCard &&
      other.redCard == redCard &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return team.hashCode ^
      corners.hashCode ^
      fouls.hashCode ^
      defense.hashCode ^
      offset.hashCode ^
      passes.hashCode ^
      possesion.hashCode ^
      shots.hashCode ^
      shotsGoal.hashCode ^
      yellowCard.hashCode ^
      redCard.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
