// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:futzada/enum/enums.dart';
import 'package:futzada/utils/date_utils.dart';

class RatingModel {
  final Roles? modality;
  final double? points;
  final double? avarage;
  final double? valuation;
  final double? price;
  final int? games;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  RatingModel({
    this.modality = Roles.Player,
    this.points = 0.0,
    this.avarage = 0.0,
    this.valuation = 0.0,
    this.price = 0.0,
    this.games = 0,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  RatingModel copyWith({
    Roles? modality,
    double? points,
    double? avarage,
    double? valuation,
    double? price,
    int? games,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return RatingModel(
      modality: modality ?? this.modality,
      points: points ?? this.points,
      avarage: avarage ?? this.avarage,
      valuation: valuation ?? this.valuation,
      price: price ?? this.price,
      games: games ?? this.games,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'modality': modality,
      'points': points,
      'avarage': avarage,
      'valuation': valuation,
      'price': price,
      'games': games,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      modality: map['modality'] != null 
        ? Roles.values.firstWhere((e) => e == map['modality']) 
        : null,
      points: map['points'] != null ? map['points'] as double : null,
      avarage: map['avarage'] != null ? map['avarage'] as double : null,
      valuation: map['valuation'] != null ? map['valuation'] as double : null,
      price: map['price'] != null ? map['price'] as double : null,
      games: map['games'] != null ? map['games'] as int : null,
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt: DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt: DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingModel.fromJson(String source) => RatingModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RatingModel(modality: $modality, points: $points, avarage: $avarage, valuation: $valuation, price: $price, games: $games, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant RatingModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.modality == modality &&
      other.points == points &&
      other.avarage == avarage &&
      other.valuation == valuation &&
      other.price == price &&
      other.games == games &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return modality.hashCode ^
      points.hashCode ^
      avarage.hashCode ^
      valuation.hashCode ^
      price.hashCode ^
      games.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
