// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TaskModel {
  final int id;
  final String uuid;
  final String title;
  final String description;
  final int points;
  final bool recurrent;

  TaskModel({
    required this.id,
    required this.uuid,
    required this.title,
    required this.description,
    required this.points,
    required this.recurrent,
  });

  TaskModel copyWith({
    int? id,
    String? uuid,
    String? title,
    String? description,
    int? points,
    bool? recurrent,
  }) {
    return TaskModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      recurrent: recurrent ?? this.recurrent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'title': title,
      'description': description,
      'points': points,
      'recurrent': recurrent,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int,
      uuid: map['uuid'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      points: map['points'] as int,
      recurrent: map['recurrent'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TaskModel(id: $id, uuid: $uuid, title: $title, description: $description, points: $points, recurrent: $recurrent)';
  }

  @override
  bool operator ==(covariant TaskModel other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.uuid == uuid &&
      other.title == title &&
      other.description == description &&
      other.points == points &&
      other.recurrent == recurrent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uuid.hashCode ^
      title.hashCode ^
      description.hashCode ^
      points.hashCode ^
      recurrent.hashCode;
  }
}
