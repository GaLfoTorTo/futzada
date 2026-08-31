// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:esportly/core/helpers/date_helper.dart';
import 'package:esportly/data/models/position_model.dart';
import 'package:esportly/data/models/rating_model.dart';

class PlayerModel {
  final int? id;
  final String bestSide;
  final String? type;
  final int? number;
  final List<PositionModel> positions;
  final List<RatingModel>? ratings;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  PlayerModel({
    this.id,
    this.bestSide = "Right",
    this.type,
    this.number,
    this.positions = const [],
    this.ratings,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  //FUNÇÃO PARA RETORNAR POSIÇÃO PRINCIPAL DO JOGADOR APARTIR DA MODALIDADE
  PositionModel? getMainPosition(String modality) => positions.where((p) => p.modality?.name == modality && p.main).firstOrNull;

  ///FUNÇÃO PARA RETORNAR TODAS AS POSIÇÕES DO JOGADOR APARTIR DA MODALIDADE
  List<PositionModel> getPositionsByModality(String modality) => positions.where((p) => p.modality?.name == modality).toList();

  ///FUNÇÃO PARA RETORNAR POSIÇÕES SECUNDARIAS DO JOGADOR APARTIR DA MODALIDADE
  List<PositionModel> getSecondaryPositions(String modality) => positions.where((p) => p.modality?.name == modality && !p.main).toList();

  PlayerModel copyWith({
    int? id,
    String? bestSide,
    String? type,
    int? number,
    List<PositionModel>? positions,
    List<RatingModel>? ratings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return PlayerModel(
      id: id ?? this.id,
      bestSide: bestSide ?? this.bestSide,
      type: type ?? this.type,
      number: number ?? this.number,
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
      'number': number,
      'positions': positions.map((x) => x.toMap()).toList(),
      'ratings': ratings?.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    return PlayerModel(
      id: map['id'] != null ? map['id'] as int : null,
      bestSide: map['bestSide'] as String? ?? 'Right',
      type: map['type'] != null ? map['type'] as String : null,
      number: map['number'] != null ? map['number'] as int : null,
      positions: map['positions'] != null
          ? List<PositionModel>.from(
              (map['positions'] as List<dynamic>).map<PositionModel>(
                (x) => PositionModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      ratings: map['ratings'] != null
          ? List<RatingModel>.from(
              (map['ratings'] as List<dynamic>).map<RatingModel>(
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

  factory PlayerModel.fromJson(String source) =>
      PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PlayerModel(id: $id, bestSide: $bestSide, type: $type, number: $number, positions: $positions, ratings: $ratings, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant PlayerModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.bestSide == bestSide &&
        other.type == type &&
        other.number == number &&
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
        number.hashCode ^
        positions.hashCode ^
        ratings.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
}
