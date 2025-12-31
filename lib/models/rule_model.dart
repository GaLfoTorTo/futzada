// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/models/participant_model.dart';

class RuleModel {
  final int? id;
  final String title;
  final String description;
  final ParticipantModel author;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RuleModel({
    this.id,
    required this.title,
    required this.description,
    required this.author,
    this.createdAt,
    this.updatedAt,
  });

  RuleModel copyWith({
    int? id,
    String? title,
    String? description,
    ParticipantModel? author,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RuleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      author: author ?? this.author,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'author': author.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory RuleModel.fromMap(Map<String, dynamic> map) {
    return RuleModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      author: ParticipantModel.fromMap(map['author'] as Map<String,dynamic>),
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RuleModel.fromJson(String source) => RuleModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RuleModel(id: $id, title: $title, description: $description, author: $author, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant RuleModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.author == author &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      author.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
