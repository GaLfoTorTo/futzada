// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:esportly/core/enum/enums.dart';

class PositionModel {
  final int? id;
  final String title;
  final String alias;
  final Modality? modality;
  final bool main;

  const PositionModel({
    this.id,
    this.title = '',
    this.alias = '',
    this.modality,
    this.main = false,
  });

  PositionModel copyWith({
    int? id,
    String? title,
    String? alias,
    Modality? modality,
    bool? main,
  }) => PositionModel(
    id: id ?? this.id,
    title: title ?? this.title,
    alias: alias ?? this.alias,
    modality: modality ?? this.modality,
    main: main ?? this.main,
  );

  Map<String, dynamic> toMap() => <String, dynamic>{
    'id': id,
    'title': title,
    'alias': alias,
    'modality': modality?.name,
    'main': main,
  };

  factory PositionModel.fromMap(Map<String, dynamic> map) {
    final pivot = map['pivot'] as Map<String, dynamic>?;
    return PositionModel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      alias: map['alias'] as String? ?? '',
      modality: map['modality'] != null
        ? Modality.values.firstWhere(
            (e) => e.name == map['modality'],
            orElse: () => Modality.Football,
          )
        : null,
      main: pivot?['main'] as bool? ?? map['main'] as bool? ?? false,
    );
  }

  String toJson() => json.encode(toMap());
  factory PositionModel.fromJson(String source) =>
      PositionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PositionModel(id: $id, title: $title, alias: $alias, modality: $modality, main: $main)';

  @override
  bool operator ==(covariant PositionModel other) {
    if (identical(this, other)) return true;
    return other.id == id &&
        other.title == title &&
        other.alias == alias &&
        other.modality == modality &&
        other.main == main;
  }

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ alias.hashCode ^ modality.hashCode ^ main.hashCode;
}
