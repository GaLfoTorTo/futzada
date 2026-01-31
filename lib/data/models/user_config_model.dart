// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/helpers/date_helper.dart';

class UserConfigModel {
  int? id;
  int? userId;
  Modality? mainModality;
  List<Modality>? modalities;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  UserConfigModel({
    this.id,
    this.userId,
    this.createdAt,
    this.mainModality,
    this.modalities,
    this.updatedAt,
    this.deletedAt,
  });

  UserConfigModel copyWith({
    int? id,
    int? userId,
    Modality? mainModality,
    List<Modality>? modalities,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return UserConfigModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mainModality: mainModality ?? this.mainModality,
      modalities: modalities ?? this.modalities,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId' : userId,
      'mainModality': mainModality?.name,
      'modalities': modalities?.map((modality) => modality.name).toList(), 
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory UserConfigModel.fromMap(Map<String, dynamic> map) {
    return UserConfigModel(
      id: map['id'] as int,
      userId : map['userId'] as int,
      mainModality : map['mainModality'] != null ? Modality.values.byName(map['mainModality']) : null,
      modalities: map['modalities'] != null
        ? (map['modalities'] as List)
            .map((e) => Modality.values.byName(e))
            .toList()
        : null,
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserConfigModel.fromJson(String source) => UserConfigModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserConfigModel(id: $id, userId: $userId, mainModality: $mainModality, modalities: $modalities, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant UserConfigModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.userId == userId &&
      other.mainModality == mainModality &&
      other.modalities == modalities &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      userId.hashCode ^
      mainModality.hashCode ^
      modalities.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
