// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/helpers/date_helper.dart';

class ParticipantModel {
  int id;
  int userId;
  int eventId;
  List<String>? role;
  List<String>? permissions;
  PlayerStatus status;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ParticipantModel({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.role,
    required this.permissions,
    this.status = PlayerStatus.Avaliable,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  ParticipantModel copyWith({
    int? id,
    int? userId,
    int? eventId,
    List<String>? role,
    List<String>? permissions,
    PlayerStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ParticipantModel(
      id: this.id,
      userId: this.userId,
      eventId: this.eventId,
      role: role ?? this.role,
      permissions: permissions ?? this.permissions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'eventId': eventId,
      'role': role,
      'permissions': permissions,
      'status': status.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt,
    };
  }

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      eventId: map['eventId'] as int,
      role: map['role'] != null 
        ? List<String>.from((map['role'] as List<dynamic>)) 
        : null,
      permissions: map['permissions'] != null 
        ? List<String>.from((map['permissions'] as List<dynamic>)) 
        : null,
      status: PlayerStatus.values.firstWhere((e) => e.name == map['status'] as String),
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ParticipantModel.fromJson(String source) => ParticipantModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ParticipantModel(id: $id, userId: $userId, eventId: $eventId, role: $role, permissions: $permissions, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant ParticipantModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.eventId == eventId &&
      listEquals(other.role, role) &&
      listEquals(other.permissions, permissions) &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      userId.hashCode ^
      eventId.hashCode ^
      role.hashCode ^
      permissions.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
