// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AchivmentModel {
  final int id;
  final String title;
  final String description;
  final int points;
  final String image;
  final String rarity;

  AchivmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.image,
    required this.rarity,
  });

  AchivmentModel copyWith({
    int? id,
    String? title,
    String? description,
    int? points,
    String? image,
    String? rarity,
  }) {
    return AchivmentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      points: points ?? this.points,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
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
    };
  }

  factory AchivmentModel.fromMap(Map<String, dynamic> map) {
    return AchivmentModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      points: map['points'] as int,
      image: map['image'] as String,
      rarity: map['rarity'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AchivmentModel.fromJson(String source) => AchivmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AchivmentModel(id: $id, title: $title, description: $description, points: $points, image: $image, rarity: $rarity)';
  }

  @override
  bool operator ==(covariant AchivmentModel other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.title == title &&
      other.description == description &&
      other.points == points &&
      other.image == image &&
      other.rarity == rarity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      points.hashCode^
      image.hashCode ^
      rarity.hashCode;
  }
}
