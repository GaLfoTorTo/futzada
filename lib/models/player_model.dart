// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PlayerModel {
  final int? id;
  final int? userId;
  final String? bestSide;
  final String? type;
  final String? positions;

  PlayerModel({
    this.id,
    this.userId,
    this.bestSide,
    this.type,
    this.positions,
  });

  PlayerModel copyWith({
    int? id,
    int? userId,
    String? bestSide,
    String? type,
    String? positions,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      bestSide: bestSide ?? this.bestSide,
      type: type ?? this.type,
      positions: positions ?? this.positions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'bestSide': bestSide,
      'type': type,
      'positions': positions,
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      bestSide: map['bestSide'] != null ? map['bestSide'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      positions: map['positions'] != null ? map['positions'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) => PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerModel(id: $id, userId: $userId, bestSide: $bestSide, type: $type, positions: $positions)';
  }

  @override
  bool operator ==(covariant PlayerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.bestSide == bestSide &&
      other.type == type &&
      other.positions == positions;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      bestSide.hashCode ^
      type.hashCode ^
      positions.hashCode;
  }
}
