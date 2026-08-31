// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ActionModel {
  final int id;
  final String title;
  final String? description;
  final String modality;
  final double? score;
  final int? requiredCount;

  ActionModel({
    required this.id,
    required this.title,
    this.description,
    required this.modality,
    this.score,
    this.requiredCount,
  });

  ActionModel copyWith({
    int? id,
    String? title,
    String? description,
    String? modality,
    double? score,
    int? requiredCount,
  }) {
    return ActionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      modality: modality ?? this.modality,
      score: score ?? this.score,
      requiredCount: requiredCount ?? this.requiredCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'modality': modality,
      'score': score,
      'requiredCount': requiredCount,
    };
  }

  factory ActionModel.fromMap(Map<String, dynamic> map) {
    return ActionModel(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      modality: map['modality'] as String,
      score: (map['score'] as num?)?.toDouble(),
      requiredCount: map['requiredCount'] as int?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActionModel.fromJson(String source) =>
      ActionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ActionModel(id: $id, title: $title, description: $description, modality: $modality, score: $score, requiredCount: $requiredCount)';
  }

  @override
  bool operator ==(covariant ActionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.description == description &&
        other.modality == modality &&
        other.score == score &&
        other.requiredCount == requiredCount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        modality.hashCode ^
        score.hashCode ^
        requiredCount.hashCode;
  }
}
