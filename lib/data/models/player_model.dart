// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/helpers/date_helper.dart';
import 'package:futzada/data/models/rating_model.dart';

class PlayerModel {
  final int? id;
  final String bestSide;
  final String? type;
  final Map<String, dynamic> mainPosition;
  final Map<String, dynamic> positions;
  final List<RatingModel>? ratings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  PlayerModel({
    this.id,
    this.bestSide = "Right",
    this.type,
    this.mainPosition = const {},
    this.positions = const {},
    this.ratings,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  PlayerModel copyWith({
    int? id,
    String? bestSide,
    String? type,
    Map<String, dynamic>? mainPosition,
    Map<String, dynamic>? positions,
    List<RatingModel>? ratings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      bestSide: bestSide ?? this.bestSide,
      type: type ?? this.type,
      mainPosition: mainPosition ?? this.mainPosition,
      positions: positions ?? this.positions,
      ratings: ratings ?? this.ratings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'bestSide': bestSide,
      'type': type,
      'mainPosition': mainPosition,
      'positions': positions,
      'ratings': ratings?.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] != null ? map['id'] as int : null,
      bestSide: map['bestSide'] as String,
      type: map['type'] != null ? map['type'] as String : null,
      mainPosition: map["mainPosition"] != null 
        ? map['mainPosition'] as Map<String, dynamic>
        : {},
      positions: map['positions'] != null 
        ? map['positions'] as Map<String, dynamic> 
        : {},
      ratings: map['ratings'] != null
        ? List<RatingModel>.from((map['ratings'] as List<dynamic>)
          .map<RatingModel>(
            (x) => RatingModel.fromMap(x),
          ),
        )
        : [],
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) => PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerModel(id: $id, bestSide: $bestSide, type: $type, mainPosition: $mainPosition, positions: $positions, ratings: $ratings, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
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
      other.ratings == ratings &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      bestSide.hashCode ^
      type.hashCode ^
      mainPosition.hashCode ^
      positions.hashCode ^
      ratings.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
