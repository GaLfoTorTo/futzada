// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/utils/date_utils.dart';

class AvaliationModel {
  final int id;
  final int userId;
  final int eventId;
  final double? avaliation;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  AvaliationModel({
    required this.id,
    required this.userId,
    required this.eventId,
    this.avaliation = 0.0,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  AvaliationModel copyWith({
    int? id,
    int? userId,
    int? eventId,
    double? avaliation,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return AvaliationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      eventId: eventId ?? this.eventId,
      avaliation: avaliation ?? this.avaliation,
      comment: comment ?? this.comment,
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
      'avaliation': avaliation,
      'comment': comment,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory AvaliationModel.fromMap(Map<String, dynamic> map) {
    return AvaliationModel(
      id: map['id'] as int,
      userId: map['userId'] as int,
      eventId: map['eventId'] as int,
      avaliation: map['avaliation'] != null ? map['avaliation'] as double : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt:  DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt:  DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AvaliationModel.fromJson(String source) => AvaliationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AvaliationModel(id: $id, userId: $userId, eventId: $eventId avaliation: $avaliation, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant AvaliationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.eventId == eventId &&
      other.avaliation == avaliation &&
      other.comment == comment &&
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
      avaliation.hashCode ^
      comment.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
