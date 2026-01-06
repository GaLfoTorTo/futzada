// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:futzada/models/manager_model.dart';
import 'package:futzada/models/player_model.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/utils/date_utils.dart';

class UserModel {
  int? id;
  String? uuid;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? bornDate;
  String? phone;
  VisibilityPerfil? visibility;
  String? photo;
  String? token;
  PlayerModel? player;
  ManagerModel? manager;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  UserModel({
    this.id,
    this.uuid,
    this.firstName,
    this.lastName,
    this.userName,
    this.email,
    this.bornDate,
    this.phone,
    this.visibility,
    this.photo,
    this.token,
    this.player,
    this.manager,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  UserModel copyWith({
    int? id,
    String? uuid,
    String? firstName,
    String? lastName,
    String? userName,
    String? email,
    String? bornDate,
    String? phone,
    VisibilityPerfil? visibility,
    String? photo,
    String? token,
    PlayerModel? player,
    ManagerModel? manager,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt
  }) {
    return UserModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      bornDate: bornDate ?? this.bornDate,
      phone: phone ?? this.phone,
      visibility: visibility ?? this.visibility,
      photo: photo ?? this.photo,
      token: token ?? this.token,
      player: player ?? this.player,
      manager: manager ?? this.manager,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'email': email,
      'bornDate': bornDate,
      'phone': phone,
      'visibility': visibility?.name,
      'photo': photo,
      'token': token,
      'player': player?.toMap(),
      'manager': manager?.toMap(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      firstName: map['firstName'] != null ? map['firstName'] as String : null,
      lastName: map['lastName'] != null ? map['lastName'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      bornDate: map['bornDate'] != null ? map['bornDate'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      visibility: map['visibility'] != null
        ? VisibilityPerfil.values.firstWhere((e) => e.name == map['visibility'])
        : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      player: map['player'] != null 
        ? PlayerModel.fromMap(map['player'] as Map<String, dynamic>) 
        : null,
      manager: map['manager'] != null 
        ? ManagerModel.fromMap(map['manager'] as Map<String, dynamic>) 
        : null,
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt: DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt: DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, uuid: $uuid, firstName: $firstName, lastName: $lastName, userName: $userName, email: $email, bornDate: $bornDate, phone: $phone, visibility: $visibility, photo: $photo, token: $token, player: $player, manager: $manager, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uuid == uuid &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.userName == userName &&
      other.email == email &&
      other.bornDate == bornDate &&
      other.phone == phone &&
      other.visibility == visibility &&
      other.photo == photo &&
      other.token == token &&
      other.player == player &&
      other.manager == manager &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uuid.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      userName.hashCode ^
      email.hashCode ^
      bornDate.hashCode ^
      phone.hashCode ^
      visibility.hashCode ^
      photo.hashCode ^
      token.hashCode ^
      player.hashCode ^
      manager.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
