// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:futzada/models/economy_model.dart';
import 'package:futzada/models/escalation_model.dart';

class ManagerModel {
  final int? id;
  final String? team;
  final String? alias;
  final String? primary;
  final String? secondary;
  final String? emblem;
  final String? uniform;
  final EscalationModel? escalation;
  final EconomyModel? economy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ManagerModel({
    this.id,
    this.team,
    this.alias,
    this.primary,
    this.secondary,
    this.emblem,
    this.uniform,
    this.escalation,
    this.economy,
    this.createdAt,
    this.updatedAt,
  });

  ManagerModel copyWith({
    int? id,
    String? team,
    String? alias,
    String? primary,
    String? secondary,
    String? emblem,
    String? uniform,
    EscalationModel? escalation,
    EconomyModel? economy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ManagerModel(
      id: id ?? this.id,
      team: team ?? this.team,
      alias: alias ?? this.alias,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      emblem: emblem ?? this.emblem,
      uniform: uniform ?? this.uniform,
      escalation: escalation ?? this.escalation,
      economy: economy ?? this.economy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'team': team,
      'alias': alias,
      'primary': primary,
      'secondary': secondary,
      'emblem': emblem,
      'uniform': uniform,
      'escalation': escalation?.toMap(),
      'economy': economy?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      id: map['id'] != null ? map['id'] as int : null,
      team: map['team'] != null ? map['team'] as String : null,
      alias: map['alias'] != null ? map['alias'] as String : null,
      primary: map['primary'] != null ? map['primary'] as String : null,
      secondary: map['secondary'] != null ? map['secondary'] as String : null,
      emblem: map['emblem'] != null ? map['emblem'] as String : null,
      uniform: map['uniform'] != null ? map['uniform'] as String : null,
      escalation: map['escalation'] != null ? EscalationModel.fromMap(map['escalation'] as Map<String,dynamic>) : null,
      economy: map['economy'] != null ? EconomyModel.fromMap(map['economy'] as Map<String,dynamic>) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ManagerModel.fromJson(String source) => ManagerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ManagerModel(id: $id, team: $team, alias: $alias, primary: $primary, secondary: $secondary, emblem: $emblem, uniform: $uniform, escalation: $escalation, economy: $economy, $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant ManagerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.team == team &&
      other.alias == alias &&
      other.primary == primary &&
      other.secondary == secondary &&
      other.emblem == emblem &&
      other.uniform == uniform &&
      other.escalation == escalation &&
      other.economy == economy &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      team.hashCode ^
      alias.hashCode ^
      primary.hashCode ^
      secondary.hashCode ^
      emblem.hashCode ^
      uniform.hashCode ^
      escalation.hashCode ^
      economy.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
