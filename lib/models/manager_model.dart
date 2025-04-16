// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ManagerModel {
  final int? id;
  final int? userId;
  final String? team;
  final String? alias;
  final String? primary;
  final String? secondary;
  final String? emblem;
  final String? uniform;

  ManagerModel({
    this.id,
    this.userId,
    this.team,
    this.alias,
    this.primary,
    this.secondary,
    this.emblem,
    this.uniform,
  });

  ManagerModel copyWith({
    int? id,
    int? userId,
    String? team,
    String? alias,
    String? primary,
    String? secondary,
    String? emblem,
    String? uniform,
  }) {
    return ManagerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      team: team ?? this.team,
      alias: alias ?? this.alias,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      emblem: emblem ?? this.emblem,
      uniform: uniform ?? this.uniform,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'team': team,
      'alias': alias,
      'primary': primary,
      'secondary': secondary,
      'emblem': emblem,
      'uniform': uniform,
    };
  }

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      id: map['id'] != null ? map['id'] as int : null,
      userId: map['userId'] != null ? map['userId'] as int : null,
      team: map['team'] != null ? map['team'] as String : null,
      alias: map['alias'] != null ? map['alias'] as String : null,
      primary: map['primary'] != null ? map['primary'] as String : null,
      secondary: map['secondary'] != null ? map['secondary'] as String : null,
      emblem: map['emblem'] != null ? map['emblem'] as String : null,
      uniform: map['uniform'] != null ? map['uniform'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ManagerModel.fromJson(String source) => ManagerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ManagerModel(id: $id, userId: $userId, team: $team, alias: $alias, primary: $primary, secondary: $secondary, emblem: $emblem, uniform: $uniform)';
  }

  @override
  bool operator ==(covariant ManagerModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.team == team &&
      other.alias == alias &&
      other.primary == primary &&
      other.secondary == secondary &&
      other.emblem == emblem &&
      other.uniform == uniform;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      team.hashCode ^
      alias.hashCode ^
      primary.hashCode ^
      secondary.hashCode ^
      emblem.hashCode ^
      uniform.hashCode;
  }
}
