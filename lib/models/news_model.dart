// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/participant_model.dart';

class NewsModel {
  final int? id;
  final String title;
  final String description;
  final NewsType type;
  final ParticipantModel? participant;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NewsModel({
    this.id,
    required this.title,
    required this.description,
    required this.type,
    this.participant,
    this.createdAt,
    this.updatedAt,
  });

  NewsModel copyWith({
    int? id,
    String? title,
    String? description,
    NewsType? type,
    ParticipantModel? participant,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NewsModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      participant: participant ?? this.participant,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'participant': participant,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      type: map['type'] as NewsType,
      participant: map['participant'] != null ? ParticipantModel.fromMap(map['participant'] as Map<String,dynamic>) : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NewsModel.fromJson(String source) => NewsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NewsModel(id: $id, title: $title, description: $description, type: $type, participant: $participant, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant NewsModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.type == type &&
      other.participant == participant &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      type.hashCode ^
      participant.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
