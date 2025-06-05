// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/models/participant_model.dart';

class EscalationModel {
  final int? id;
  final String? formation;
  final Map<int, ParticipantModel?>? starters;
  final Map<int, ParticipantModel?>? reserves;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EscalationModel({
    this.id,
    this.formation,
    this.starters,
    this.reserves,
    this.createdAt,
    this.updatedAt,
  });

  EscalationModel copyWith({
    int? id,
    String? formation,
    Map<int, ParticipantModel?>? starters,
    Map<int, ParticipantModel?>? reserves,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EscalationModel(
      id: id ?? this.id,
      formation: formation ?? this.formation,
      starters: starters ?? this.starters,
      reserves: reserves ?? this.reserves,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'formation': formation,
      'starters': starters,
      'reserves': reserves,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory EscalationModel.fromMap(Map<String, dynamic> map) {
    return EscalationModel(
      id: map['id'] != null ? map['id'] as int : null,
      formation: map['formation'] != null ? map['formation'] as String : null,
      starters: map['starters'] != null ? Map<int, ParticipantModel?>.from((map['starters'] as Map<int, ParticipantModel?>)) : null,
      reserves: map['reserves'] != null ? Map<int, ParticipantModel?>.from((map['reserves'] as Map<int, ParticipantModel?>)) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EscalationModel.fromJson(String source) => EscalationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EscalationModel(id: $id, formation: $formation, starters: $starters, reserves: $reserves, $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant EscalationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.formation == formation &&
      mapEquals(other.starters, starters) &&
      mapEquals(other.reserves, reserves) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      formation.hashCode ^
      starters.hashCode ^
      reserves.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
