// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/models/user_model.dart';

class PlayerModel {
  final int? id;
  final UserModel user;
  final String bestSide;
  final String? type;
  final String positions;
  final String position;
  final String status;
  final double? lastPontuation;
  final double? media;
  final double? price;
  final double? valorization;
  final int? games;

  PlayerModel({
    this.id,
    required this.user,
    required this.bestSide,
    required this.type,
    required this.positions,
    required this.position,
    required this.status,
    required this.lastPontuation,
    required this.media,
    required this.price,
    required this.valorization,
    required this.games,
  });

  PlayerModel copyWith({
    int? id,
    UserModel? user,
    String? bestSide,
    String? type,
    String? positions,
    String? position,
    String? status,
    double? lastPontuation,
    double? media,
    double? price,
    double? valorization,
    int? games,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      user: user ?? this.user,
      bestSide: bestSide ?? this.bestSide,
      type: type ?? this.type,
      positions: positions ?? this.positions,
      position: position ?? this.position,
      status: status ?? this.status,
      lastPontuation: lastPontuation ?? this.lastPontuation,
      media: media ?? this.media,
      price: price ?? this.price,
      valorization: valorization ?? this.valorization,
      games: games ?? this.games,
    );
  }
  
  PlayerModel copyWithMap({
    int? id,
    UserModel? user,
    String? bestSide,
    String? type,
    String? positions,
    String? position,
    String? status,
    double? lastPontuation,
    double? media,
    double? price,
    double? valorization,
    int? games,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      user: user ?? this.user,
      bestSide: bestSide ?? this.bestSide,
      type: type ?? this.type,
      positions: positions ?? this.positions,
      position: position ?? this.position,
      status: status ?? this.status,
      lastPontuation: lastPontuation ?? this.lastPontuation,
      media: media ?? this.media,
      price: price ?? this.price,
      valorization: valorization ?? this.valorization,
      games: games ?? this.games,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'bestSide': bestSide,
      'type': type,
      'positions': positions,
      'position': position,
      'status': status,
      'lastPontuation': lastPontuation,
      'media': media,
      'price': price,
      'valorization': valorization,
      'games': games,
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] as int,
      user: UserModel.fromMap(map['user'] as Map<String,dynamic>),
      bestSide: map['bestSide'] as String,
      type: map['type'] != null ? map['type'] as String : null,
      positions: map['positions'] as String,
      position: map['position'] as String,
      status: map['status'] as String,
      lastPontuation: map['lastPontuation'] != null ? map['lastPontuation'] as double : null,
      media: map['media'] != null ? map['media'] as double : null,
      price: map['price'] != null ? map['price'] as double : null,
      valorization: map['valorization'] != null ? map['valorization'] as double : null,
      games: map['games'] != null ? map['games'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) => PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerModel(id: $id, user: $user, bestSide: $bestSide, type: $type, positions: $positions, position: $position, status: $status, lastPontuation: $lastPontuation, media: $media, price: $price, valorization: $valorization, games: $games)';
  }

  @override
  bool operator ==(covariant PlayerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user == user &&
      other.bestSide == bestSide &&
      other.type == type &&
      other.positions == positions &&
      other.position == position &&
      other.status == status &&
      other.lastPontuation == lastPontuation &&
      other.media == media &&
      other.price == price &&
      other.valorization == valorization &&
      other.games == games;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      bestSide.hashCode ^
      type.hashCode ^
      positions.hashCode ^
      position.hashCode ^
      status.hashCode ^
      lastPontuation.hashCode ^
      media.hashCode ^
      price.hashCode ^
      valorization.hashCode ^
      games.hashCode;
  }
}
