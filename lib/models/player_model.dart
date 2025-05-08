// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/models/user_model.dart';

class PlayerModel {
  final int? id;
  final UserModel user;
  final String bestSide;
  final String? type;
  final String mainPosition;
  final String positions;
  final double? currentPontuation;
  final double? lastPontuation;
  final double? media;
  final double? price;
  final double? valorization;
  final int? games;
  final String status;

  PlayerModel({
    this.id,
    required this.user,
    required this.bestSide,
    required this.type,
    required this.mainPosition,
    required this.positions,
    required this.currentPontuation,
    required this.lastPontuation,
    required this.media,
    required this.price,
    required this.valorization,
    required this.games,
    required this.status,
  });


  PlayerModel copyWith({
    int? id,
    UserModel? user,
    String? bestSide,
    String? type,
    String? mainPosition,
    String? positions,
    double? currentPontuation,
    double? lastPontuation,
    double? media,
    double? price,
    double? valorization,
    int? games,
    String? status,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      user: user ?? this.user,
      bestSide: bestSide ?? this.bestSide,
      type: type ?? this.type,
      mainPosition: mainPosition ?? this.mainPosition,
      positions: positions ?? this.positions,
      currentPontuation: currentPontuation ?? this.currentPontuation,
      lastPontuation: lastPontuation ?? this.lastPontuation,
      media: media ?? this.media,
      price: price ?? this.price,
      valorization: valorization ?? this.valorization,
      games: games ?? this.games,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'bestSide': bestSide,
      'type': type,
      'mainPosition': mainPosition,
      'positions': positions,
      'currentPontuation': currentPontuation,
      'lastPontuation': lastPontuation,
      'media': media,
      'price': price,
      'valorization': valorization,
      'games': games,
      'status': status,
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] != null ? map['id'] as int : null,
      user: UserModel.fromMap(map['user'] as Map<String,dynamic>),
      bestSide: map['bestSide'] as String,
      type: map['type'] != null ? map['type'] as String : null,
      mainPosition: map['mainPosition'] as String,
      positions: map['positions'] as String,
      currentPontuation: map['currentPontuation'] != null ? map['currentPontuation'] as double : null,
      lastPontuation: map['lastPontuation'] != null ? map['lastPontuation'] as double : null,
      media: map['media'] != null ? map['media'] as double : null,
      price: map['price'] != null ? map['price'] as double : null,
      valorization: map['valorization'] != null ? map['valorization'] as double : null,
      games: map['games'] != null ? map['games'] as int : null,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) => PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerModel(id: $id, user: $user, bestSide: $bestSide, type: $type, mainPosition: $mainPosition, positions: $positions, currentPontuation: $currentPontuation, lastPontuation: $lastPontuation, media: $media, price: $price, valorization: $valorization, games: $games, status: $status)';
  }

  @override
  bool operator ==(covariant PlayerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user == user &&
      other.bestSide == bestSide &&
      other.type == type &&
      other.mainPosition == mainPosition &&
      other.positions == positions &&
      other.currentPontuation == currentPontuation &&
      other.lastPontuation == lastPontuation &&
      other.media == media &&
      other.price == price &&
      other.valorization == valorization &&
      other.games == games &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      bestSide.hashCode ^
      type.hashCode ^
      mainPosition.hashCode ^
      positions.hashCode ^
      currentPontuation.hashCode ^
      lastPontuation.hashCode ^
      media.hashCode ^
      price.hashCode ^
      valorization.hashCode ^
      games.hashCode ^
      status.hashCode;
  }
}
