// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/core/utils/date_utils.dart';

class EscalationModel {
  final int? id;
  final int? eventId;
  final String? formation;
  final List<int?>? starters;
  final List<int?>? reserves;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EscalationModel({
    this.id,
    this.eventId,
    this.formation,
    this.starters,
    this.reserves,
    this.createdAt,
    this.updatedAt,
  });

  EscalationModel copyWith({
    int? id,
    int? eventId,
    String? formation,
    List<int?>? starters,
    List<int?>? reserves,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EscalationModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
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
      'eventId': eventId,
      'formation': formation,
      'starters': starters!.map((x) => x).toList(),
      'reserves': reserves!.map((x) => x).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory EscalationModel.fromMap(Map<String, dynamic> map) {
    return EscalationModel(
      id: map['id'] as int,
      eventId: map['eventId'] as int,
      formation: map['formation'] != null ? map['formation'] as String : null,
      starters: map['starters'] != null
        ? List<int?>.from(
            (map['starters'] as List<dynamic>).map<int?>(
              (x) => x != null ? x as int : null,
            ),
          ) 
        : List.filled(11, null),
      reserves: map['reserves'] != null 
        ? List<int?>.from(
            (map['reserves'] as List<dynamic>).map<int?>(
              (x) => x != null ? x as int : null,
            ),
          ) 
        : List.filled(11, null),
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt:  DatetimeUtils.parseDate(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EscalationModel.fromJson(String source) => EscalationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EscalationModel(id: $id, eventId: $eventId, formation: $formation, starters: $starters, reserves: $reserves, $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant EscalationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventId == eventId &&
      other.formation == formation &&
      listEquals(other.starters, starters) &&
      listEquals(other.reserves, reserves) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      eventId.hashCode ^
      formation.hashCode ^
      starters.hashCode ^
      reserves.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
