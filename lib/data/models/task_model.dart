// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskModel {
  final int id;
  final String uuid;
  final String title;
  final String? description;
  final int points;
  final String category;
  final String? modality;
  final bool? completed;
  final String? completedAt;

  TaskModel({
    required this.id,
    required this.uuid,
    required this.title,
    this.description,
    required this.points,
    required this.category,
    this.modality,
    this.completed,
    this.completedAt,
  });

  TaskModel copyWith({
    int? id,
    String? uuid,
    String? title,
    String? description,
    int? points,
    String? category,
    String? modality,
    bool? completed,
    String? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      category: category ?? this.category,
      modality: modality ?? this.modality,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'title': title,
      'description': description,
      'points': points,
      'category': category,
      'modality': modality,
      'completed': completed,
      'completedAt': completedAt,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int,
      uuid: map['uuid'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      points: map['points'] as int,
      category: map['category'] as String,
      modality: map['modality'] as String?,
      completed: map['completed'] as bool?,
      completedAt: map['completedAt'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uuid: $uuid, title: $title, description: $description, points: $points, category: $category, modality: $modality, completed: $completed, completedAt: $completedAt)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.uuid == uuid &&
        other.title == title &&
        other.description == description &&
        other.points == points &&
        other.category == category &&
        other.modality == modality &&
        other.completed == completed &&
        other.completedAt == completedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        uuid.hashCode ^
        title.hashCode ^
        description.hashCode ^
        points.hashCode ^
        category.hashCode ^
        modality.hashCode ^
        completed.hashCode ^
        completedAt.hashCode;
  }
}
