// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/helpers/date_helper.dart';

class EconomyModel {
  final int? id;
  final int? managerId;
  final int? eventId;
  final double? patrimony;
  final double? price;
  final double? valuation;
  final double? points;
  final double? totalPoints;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  EconomyModel({
    this.id,
    this.eventId,
    this.managerId,
    this.patrimony,
    this.price,
    this.valuation,
    this.points,
    this.totalPoints,
    this.createdAt,
    this.updatedAt,
  });

  EconomyModel copyWith({
    int? id,
    int? eventId,
    int? managerId,
    double? patrimony,
    double? price,
    double? valuation,
    double? points,
    double? totalPoints,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return EconomyModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      managerId: managerId ?? this.managerId,
      patrimony: patrimony ?? this.patrimony,
      price: price ?? this.price,
      valuation: valuation ?? this.valuation,
      points: points ?? this.points,
      totalPoints: totalPoints ?? this.totalPoints,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'managerId': managerId,
      'patrimony': patrimony,
      'price': price,
      'valuation': valuation,
      'points': points,
      'totalPoints': totalPoints,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory EconomyModel.fromMap(Map<String, dynamic> map) {
    return EconomyModel(
      id: map['id'] as int,
      eventId: map['eventId'] as int,
      managerId: map['managerId'] as int,
      patrimony: map['patrimony'] != null ? map['patrimony'] as double : null,
      price: map['price'] != null ? map['price'] as double : null,
      valuation: map['valuation'] != null ? map['valuation'] as double : null,
      points: map['points'] != null ? map['points'] as double : null,
      totalPoints: map['totalPoints'] != null ? map['totalPoints'] as double : null,
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt:  DateHelper.parseDate(map['updatedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EconomyModel.fromJson(String source) => EconomyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EconomyModel(id: $id, eventId: $eventId, managerId: $managerId, patrimony: $patrimony, price: $price, valuation: $valuation, points: $points, totalPoints: $totalPoints, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant EconomyModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventId == eventId &&
      other.managerId == managerId &&
      other.patrimony == patrimony &&
      other.price == price &&
      other.valuation == valuation &&
      other.points == points &&
      other.totalPoints == totalPoints &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      eventId.hashCode ^
      managerId.hashCode ^
      patrimony.hashCode ^
      price.hashCode ^
      valuation.hashCode ^
      points.hashCode ^
      totalPoints.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
