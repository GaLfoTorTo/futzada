// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EconomyModel {
  final double? patrimony;
  final double? price;
  final double? valuation;
  final double? points;
  final double? totalPoints;

  EconomyModel({
    this.patrimony,
    this.price,
    this.valuation,
    this.points,
    this.totalPoints,
  });

  EconomyModel copyWith({
    double? patrimony,
    double? price,
    double? valuation,
    double? points,
    double? totalPoints,
  }) {
    return EconomyModel(
      patrimony: patrimony ?? this.patrimony,
      price: price ?? this.price,
      valuation: valuation ?? this.valuation,
      points: points ?? this.points,
      totalPoints: totalPoints ?? this.totalPoints,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'patrimony': patrimony,
      'price': price,
      'valuation': valuation,
      'points': points,
      'totalPoints': totalPoints,
    };
  }

  factory EconomyModel.fromMap(Map<String, dynamic> map) {
    return EconomyModel(
      patrimony: map['patrimony'] != null ? map['patrimony'] as double : null,
      price: map['price'] != null ? map['price'] as double : null,
      valuation: map['valuation'] != null ? map['valuation'] as double : null,
      points: map['points'] != null ? map['points'] as double : null,
      totalPoints: map['totalPoints'] != null ? map['totalPoints'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EconomyModel.fromJson(String source) => EconomyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EconomyModel(patrimony: $patrimony, price: $price, valuation: $valuation, points: $points, totalPoints: $totalPoints)';
  }

  @override
  bool operator ==(covariant EconomyModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.patrimony == patrimony &&
      other.price == price &&
      other.valuation == valuation &&
      other.points == points &&
      other.totalPoints == totalPoints;
  }

  @override
  int get hashCode {
    return patrimony.hashCode ^
      price.hashCode ^
      valuation.hashCode ^
      points.hashCode ^
      totalPoints.hashCode;
  }
}
