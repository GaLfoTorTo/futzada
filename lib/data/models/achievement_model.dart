// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:esportly/core/enum/enums.dart';

class AchievementModel {
  final int id;
  final String title;
  final String description;
  final int points;
  final String image;
  final AchievementType type;
  final String rarity;
  final bool status;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.image,
    required this.type,
    required this.rarity,
    required this.status,
  });

  AchievementModel copyWith({
    int? id,
    String? title,
    String? description,
    int? points,
    String? image,
    AchievementType? type,
    String? rarity,
    bool? status,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      image: image ?? this.image,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'points': points,
      'image': image,
      'type': type.name,
      'rarity': rarity,
      'status': status,
    };
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      points: map['points'] as int,
      image: map['image'] as String,
      type: AchievementType.values.firstWhere((e) => e.name == map['type']),
      rarity: map['rarity'] as String,
      status: map['status'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory AchievementModel.fromJson(String source) => AchievementModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AchievementModel(id: $id, title: $title, description: $description, points: $points, image: $image, type: $type, rarity: $rarity, status: $status)';
  }

  @override
  bool operator ==(covariant AchievementModel other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.points == points &&
      other.image == image &&
      other.type == type &&
      other.rarity == rarity&&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      points.hashCode^
      image.hashCode ^
      type.hashCode ^
      rarity.hashCode^
      status.hashCode;
  }
}
