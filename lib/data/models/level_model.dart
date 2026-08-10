// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class LevelModel {
  final int id;
  final int number;
  final String tier;
  final int points;
  final int pointsMin;
  final int pointsMax;
  final String image;
  final String color;

  LevelModel({
    required this.id,
    required this.number,
    required this.tier,
    required this.points,
    required this.pointsMin,
    required this.pointsMax,
    required this.image,
    required this.color,
  });

  LevelModel copyWith({
    int? id,
    int? number,
    String? tier,
    int? points,
    int? pointsMin,
    int? pointsMax,
    String? image,
    String? color,
  }) {
    return LevelModel(
      id: id ?? this.id,
      number: number ?? this.number,
      tier: tier ?? this.tier,
      points: points ?? this.points,
      pointsMin: pointsMin ?? this.pointsMin,
      pointsMax: pointsMax ?? this.pointsMax,
      image: image ?? this.image,
      color: color ?? this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'number': number,
      'tier': tier,
      'points': points,
      'points_min': pointsMin,
      'points_max': pointsMax,
      'image': image,
      'color': color,
    };
  }

  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'] as int,
      number: map['number'] as int,
      tier: map['tier'] as String,
      points: map['points'] as int,
      pointsMin: map['points_min'] as int,
      pointsMax: map['points_max'] as int,
      image: map['image'] as String,
      color: map['color'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LevelModel.fromJson(String source) => LevelModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LevelModel(id: $id, number: $number, tier: $tier, points: $points, pointsMin: $pointsMin, pointsMax: $pointsMax, image: $image, color: $color)';
  }

  @override
  bool operator ==(covariant LevelModel other) {
    if (identical(this, other)) return true;

    return 
      other.id == id &&
      other.number == number &&
      other.tier == tier &&
      other.points == points &&
      other.pointsMin == pointsMin &&
      other.pointsMax == pointsMax &&
      other.image == image &&
      other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      number.hashCode ^
      tier.hashCode ^
      points.hashCode ^
      pointsMin.hashCode ^
      pointsMax.hashCode ^
      image.hashCode ^
      color.hashCode;
  }
}
