// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/helpers/date_helper.dart';
import 'package:futzada/data/models/economy_model.dart';
import 'package:futzada/data/models/escalation_model.dart';

class ManagerModel {
  int? id;
  int? userId;
  String? team;
  String? alias;
  String? primary;
  String? secondary;
  String? emblem;
  String? uniform;
  List<EscalationModel>? escalations;
  List<EconomyModel>? economies;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  ManagerModel({
    this.id,
    this.userId,
    this.team,
    this.alias,
    this.primary,
    this.secondary,
    this.emblem,
    this.uniform,
    this.escalations,
    this.economies,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ManagerModel copyWith({
    int? id,
    String? team,
    String? alias,
    String? primary,
    String? secondary,
    String? emblem,
    String? uniform,
    List<EscalationModel>? escalations,
    List<EconomyModel>? economies,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return ManagerModel(
      id: id ?? this.id,
      team: team ?? this.team,
      alias: alias ?? this.alias,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      emblem: emblem ?? this.emblem,
      uniform: uniform ?? this.uniform,
      escalations: escalations ?? this.escalations,
      economies: economies ?? this.economies,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'team': team,
      'alias': alias,
      'primary': primary,
      'secondary': secondary,
      'emblem': emblem,
      'uniform': uniform,
      'escalations': escalations?.map((x) => x.toMap()).toList(),
      'economies': economies?.map((x) => x.toMap()).toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      id: map['id'] != null ? map['id'] as int : null,
      team: map['team'] != null ? map['team'] as String : null,
      alias: map['alias'] != null ? map['alias'] as String : null,
      primary: map['primary'] != null ? map['primary'] as String : null,
      secondary: map['secondary'] != null ? map['secondary'] as String : null,
      emblem: map['emblem'] != null ? map['emblem'] as String : null,
      uniform: map['uniform'] != null ? map['uniform'] as String : null,
      escalations: map['escalations'] != null
        ? List<EscalationModel>.from((map['escalations'] as List<dynamic>)
          .map<EscalationModel>(
            (x) => EscalationModel.fromMap(x),
          ),
        )
        : [],
      economies: map['economies'] != null
        ? List<EconomyModel>.from((map['economies'] as List<dynamic>)
          .map<EconomyModel>(
            (x) => EconomyModel.fromMap(x),
          ),
        )
        : [],
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ManagerModel.fromJson(String source) => ManagerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ManagerModel(id: $id, team: $team, alias: $alias, primary: $primary, secondary: $secondary, emblem: $emblem, uniform: $uniform, escalations: $escalations, economies: $economies, $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant ManagerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.team == team &&
      other.alias == alias &&
      other.primary == primary &&
      other.secondary == secondary &&
      other.emblem == emblem &&
      other.uniform == uniform &&
      other.escalations == escalations &&
      other.economies == economies &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      team.hashCode ^
      alias.hashCode ^
      primary.hashCode ^
      secondary.hashCode ^
      emblem.hashCode ^
      uniform.hashCode ^
      escalations.hashCode ^
      economies.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
