// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/helpers/date_helper.dart';

class RuleModel {
  int? id;
  int eventId;
  String title;
  String description;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  RuleModel({
    this.id,
    required this.eventId,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  RuleModel copyWith({
    int? id,
    int? eventId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return RuleModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'title': title,
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': updatedAt?.toIso8601String(),
    };
  }

  factory RuleModel.fromMap(Map<String, dynamic> map) {
    return RuleModel(
      id: map['id'],
      eventId: map['eventId'],
      title: map['title'],
      description: map['description'],
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RuleModel.fromJson(String source) => RuleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RuleModel(id: $id, eventId: $eventId, title: $title, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant RuleModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventId == eventId &&
      other.title == title &&
      other.description == description &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      eventId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
