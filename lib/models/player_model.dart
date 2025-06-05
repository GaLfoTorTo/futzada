// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/models/rating_model.dart';

class PlayerModel {
  final int? id;
  final String bestSide;
  final String? type;
  final String mainPosition;
  final String positions;
  final RatingModel? rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlayerModel({
    this.id,
    required this.bestSide,
    required this.type,
    required this.mainPosition,
    required this.positions,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  PlayerModel copyWith({
    int? id,
    String? bestSide,
    String? type,
    String? mainPosition,
    String? positions,
    RatingModel? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      bestSide: bestSide ?? this.bestSide,
      type: type ?? this.type,
      mainPosition: mainPosition ?? this.mainPosition,
      positions: positions ?? this.positions,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bestSide': bestSide,
      'type': type,
      'mainPosition': mainPosition,
      'positions': positions,
      'rating': rating?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] != null ? map['id'] as int : null,
      bestSide: map['bestSide'] as String,
      type: map['type'] != null ? map['type'] as String : null,
      mainPosition: map['mainPosition'] as String,
      positions: map['positions'] as String,
      rating: map['rating'] != null 
        ? RatingModel.fromMap(map['rating'] as Map<String,dynamic>) 
        : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) => PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerModel(id: $id, bestSide: $bestSide, type: $type, mainPosition: $mainPosition, positions: $positions, rating: $rating, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant PlayerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.bestSide == bestSide &&
      other.type == type &&
      other.mainPosition == mainPosition &&
      other.positions == positions &&
      other.rating == rating &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      bestSide.hashCode ^
      type.hashCode ^
      mainPosition.hashCode ^
      positions.hashCode ^
      rating.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
