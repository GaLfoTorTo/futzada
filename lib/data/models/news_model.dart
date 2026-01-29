// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/utils/date_utils.dart';

class NewsModel {
  int? id;
  int? eventId;
  int? userId;
  String title;
  String description;
  NewsType type;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  NewsModel({
    required this.id,
    required this.eventId,
    this.userId,
    required this.title,
    required this.description,
    required this.type,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  NewsModel copyWith({
    int? id,
    int? eventId,
    int? userId,
    String? title,
    String? description,
    NewsType? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return NewsModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'],
      eventId: map['eventId'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      type: map['type'] as NewsType,
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt: DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt: DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) => NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsModel(id: $id, eventId: $eventId, userId: $userId, title: $title, description: $description, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant NewsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventId == eventId &&
      other.userId == userId &&
      other.title == title &&
      other.description == description &&
      other.type == type &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      eventId.hashCode ^
      userId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      type.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
