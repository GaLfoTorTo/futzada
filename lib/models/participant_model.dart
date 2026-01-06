// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/utils/date_utils.dart';

class ParticipantModel {
  final int id;
  final UserModel user;
  final List<String>? role;
  final List<String>? permissions;
  final PlayerStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  ParticipantModel({
    required this.id,
    required this.user,
    required this.role,
    required this.permissions,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  ParticipantModel copyWith({
    int? id,
    UserModel? user,
    List<String>? role,
    List<String>? permissions,
    PlayerStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ParticipantModel(
      id: this.id,
      user: this.user,
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
      'user': user.toMap(),
      'role': role,
      'permissions': permissions,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt,
    };
  }

  factory ParticipantModel.fromMap(Map<String, dynamic> map) {
    return ParticipantModel(
      id: map['id'] as int,
      user: UserModel.fromMap(map['user'] as Map<String,dynamic>),
      role: map['role'] != null 
        ? List<String>.from((map['role'] as List<String>)) 
        : null,
      permissions: map['permissions'] != null 
        ? List<String>.from((map['permissions'] as List<String>)) 
        : null,
      status: PlayerStatus.values.firstWhere((e) => e == map['status']),
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt: DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt: DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ParticipantModel.fromJson(String source) => ParticipantModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ParticipantModel(id: $id, user: $user, role: $role, permissions: $permissions, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant ParticipantModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user == user &&
      listEquals(other.role, role) &&
      listEquals(other.permissions, permissions) &&
      other.status == status &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      role.hashCode ^
      permissions.hashCode ^
      status.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
