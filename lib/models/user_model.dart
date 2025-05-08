// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:futzada/models/manager_model.dart';
import 'package:futzada/models/player_model.dart';
import 'package:futzada/enum/enums.dart';

class UserModel {
  final int? id;
  final String? uuid;
  final String? firstName;
  final String? lastName;
  final String? userName;
  final String? email;
  final String? bornDate;
  final String? phone;
  final VisibilityPerfil? visibility;
  final String? photo;
  final String? token;
  final PlayerModel? player;
  final ManagerModel? manager;

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
    );
  }

  UserModel copyWithMap({
    Map<String, dynamic>? updates,
  }) {
    return UserModel(
      id: updates?['id'] ?? id,
      uuid: updates?['uuid'] ?? uuid,
      firstName: updates?['firstName'] ?? firstName,
      lastName: updates?['lastName'] ?? lastName,
      userName: updates?['userName'] ?? userName,
      email: updates?['email'] ?? email,
      bornDate: updates?['bornDate'] ?? bornDate,
      phone: updates?['phone'] ?? phone,
      visibility: updates?['visibility'] ?? visibility,
      photo: updates?['photo'] ?? photo,
      token: updates?['token'] ?? token,
      // ATUALIZANDO PLAYER
      player: PlayerModel(
        user: this,
        bestSide: updates?['player.bestSide'] ?? player?.bestSide,
        type: updates?['player.type'] ?? player?.type,
        positions: updates?['player.positions'] ?? player?.positions,
        mainPosition: updates?['player.mainPosition'] ?? player?.mainPosition,
        currentPontuation: updates?['player.currentPontuation'] ?? player?.currentPontuation,
        lastPontuation: updates?['player.lastPontuation'] ?? player?.lastPontuation,
        media: updates?['player.media'] ?? player?.media,
        price: updates?['player.price'] ?? player?.price,
        valorization: updates?['player.valorization'] ?? player?.valorization,
        games: updates?['player.games'] ?? player?.games,
        status: updates?['player.status'] ?? player?.status,
      ),
      // ATUALIZANDO MANAGER
      manager: ManagerModel(
        team: updates?['manager.team'] ?? manager?.team,
        alias: updates?['manager.alias'] ?? manager?.alias,
        primary: updates?['manager.primary'] ?? manager?.primary,
        secondary: updates?['manager.secondary'] ?? manager?.secondary,
        emblem: updates?['manager.emblem'] ?? manager?.emblem,
        uniform: updates?['manager.uniform'] ?? manager?.uniform,
      ),
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
      player: map['player'] != null ? PlayerModel.fromMap(map['player'] as Map<String,dynamic>) : null,
      manager: map['manager'] != null ? ManagerModel.fromMap(map['manager'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, uuid: $uuid, firstName: $firstName, lastName: $lastName, userName: $userName, email: $email, bornDate: $bornDate, phone: $phone, visibility: $visibility, photo: $photo, token: $token, player: $player, manager: $manager)';
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
      other.manager == manager;
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
      manager.hashCode;
  }
}
