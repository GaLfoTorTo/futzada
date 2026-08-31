// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:esportly/data/models/action_model.dart';
import 'package:esportly/data/models/task_model.dart';

class AchievementModel {
  final int id;
  final String title;
  final String? description;
  final int points;
  final String image;
  final String rarity;
  final bool status;
  final List<ActionModel>? actions;
  final List<TaskModel>? tasks;

  AchievementModel({
    required this.id,
    required this.title,
    this.description,
    required this.points,
    required this.image,
    required this.rarity,
    required this.status,
    this.actions,
    this.tasks,
  });

  AchievementModel copyWith({
    int? id,
    String? title,
    String? description,
    int? points,
    String? image,
    String? rarity,
    bool? status,
    List<ActionModel>? actions,
    List<TaskModel>? tasks,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      status: status ?? this.status,
      actions: actions ?? this.actions,
      tasks: tasks ?? this.tasks,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'image': image,
      'rarity': rarity,
      'status': status,
      'actions': actions?.map((a) => a.toMap()).toList(),
      'tasks': tasks?.map((t) => t.toMap()).toList(),
    };
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      points: map['points'] as int,
      image: map['image'] as String,
      rarity: map['rarity'] as String,
      status: map['status'] as bool,
      actions: map['actions'] != null
          ? (map['actions'] as List)
              .map((e) => ActionModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
      tasks: map['tasks'] != null
          ? (map['tasks'] as List)
              .map((e) => TaskModel.fromMap(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AchievementModel.fromJson(String source) =>
      AchievementModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AchievementModel(id: $id, title: $title, description: $description, points: $points, image: $image, rarity: $rarity, status: $status, actions: $actions, tasks: $tasks)';
  }

  @override
  bool operator ==(covariant AchievementModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.points == points &&
        other.image == image &&
        other.rarity == rarity &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        points.hashCode ^
        image.hashCode ^
        rarity.hashCode ^
        status.hashCode;
  }
}
