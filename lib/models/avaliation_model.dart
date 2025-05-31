// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/models/user_model.dart';

class AvaliationModel {
  final int id;
  final UserModel user;
  final double? avaliation;
  final String? comment;
  final String? createdAt;
  final String? updatedAt;

  AvaliationModel({
    required this.id,
    required this.user,
    this.avaliation = 0.0,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  AvaliationModel copyWith({
    int? id,
    UserModel? user,
    double? avaliation,
    String? comment,
    String? createdAt,
    String? updatedAt,
  }) {
    return AvaliationModel(
      id: id ?? this.id,
      user: user ?? this.user,
      avaliation: avaliation ?? this.avaliation,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'avaliation': avaliation,
      'comment': comment,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory AvaliationModel.fromMap(Map<String, dynamic> map) {
    return AvaliationModel(
      id: map['id'] as int,
      user: UserModel.fromMap(map['user'] as Map<String,dynamic>),
      avaliation: map['avaliation'] != null ? map['avaliation'] as double : null,
      comment: map['comment'] != null ? map['comment'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvaliationModel.fromJson(String source) => AvaliationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AvaliationModel(id: $id, user: $user, avaliation: $avaliation, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant AvaliationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user == user &&
      other.avaliation == avaliation &&
      other.comment == comment &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      avaliation.hashCode ^
      comment.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
