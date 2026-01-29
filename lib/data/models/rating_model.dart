// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/utils/date_utils.dart';

class RatingModel {
  int? id;
  int? eventId;
  int? userId;
  Roles? role;
  double? points;
  double? avarage;
  double? valuation;
  double? price;
  int? games;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  RatingModel({
    this.id,
    this.eventId,
    this.userId,
    this.role,
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
    int? id,
    int? eventId,
    int? userId,
    Roles? role,
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
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
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
      'id': id,
      'eventId': eventId,
      'userId': userId,
      'role': role,
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
      id: map['id'] as int,
      eventId: map['eventId'] as int,
      userId: map['userId'] as int,
      role: map['role'] as Roles,
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
    return 'RatingModel(id: $id,eventId: $eventId, userId: $userId, role: $role, points: $points, avarage: $avarage, valuation: $valuation, price: $price, games: $games, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant RatingModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventId == eventId &&
      other.userId == userId &&
      other.role == role &&
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
    return 
      id.hashCode ^
      eventId.hashCode ^
      userId.hashCode ^
      role.hashCode ^
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
