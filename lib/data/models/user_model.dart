// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/core/helpers/date_helper.dart';
import 'package:futzada/data/models/manager_model.dart';
import 'package:futzada/data/models/participant_model.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/data/models/user_config_model.dart';

class UserModel {
  int? id;
  String? uuid;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? bornDate;
  String? phone;
  String? photo;
  Privacy? privacy;
  UserConfigModel? config;
  PlayerModel? player;
  ManagerModel? manager;
  List<ParticipantModel>? participants;
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
    this.privacy,
    this.photo,
    this.config,
    this.player,
    this.manager,
    this.participants,
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
    String? photo,
    Privacy? privacy,
    UserConfigModel? config,
    PlayerModel? player,
    ManagerModel? manager,
    List<ParticipantModel>? participants,
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
      photo: photo ?? this.photo,
      config: config ?? this.config,
      privacy: privacy ?? this.privacy,
      player: player ?? this.player,
      manager: manager ?? this.manager,
      participants: participants ?? this.participants,
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
      'photo': photo,
      'config': config?.toMap(),
      'privacy': privacy?.name,
      'player': player?.toMap(),
      'manager': manager?.toMap(),
      'participants': participants?.map((x) => x.toMap()).toList(),
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
      config: map['config'] != null 
        ? UserConfigModel.fromMap(map['config'] as Map<String, dynamic>) 
        : null,
      privacy: map['privacy'] != null
        ? Privacy.values.firstWhere((e) => e.name == map['privacy'])
        : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      player: map['player'] != null 
        ? PlayerModel.fromMap(map['player'] as Map<String, dynamic>) 
        : null,
      manager: map['manager'] != null 
        ? ManagerModel.fromMap(map['manager'] as Map<String, dynamic>) 
        : null,
      participants: map['participants'] != null 
        ? List<ParticipantModel>.from((map['participants'] as List<dynamic>)
          .map<ParticipantModel>(
            (x) => ParticipantModel.fromMap(x),
          ),
        )
        : [],
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt: DateHelper.parseDate(map['updatedAt']),
      deletedAt: DateHelper.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(id: $id, uuid: $uuid, firstName: $firstName, lastName: $lastName, userName: $userName, email: $email, bornDate: $bornDate, phone: $phone, privacy: $privacy, photo: $photo, player: $player, manager: $manager, participants: $participants, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
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
      other.privacy == privacy &&
      other.photo == photo &&
      other.player == player &&
      other.manager == manager &&
      other.participants == participants &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      uuid.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      userName.hashCode ^
      email.hashCode ^
      bornDate.hashCode ^
      phone.hashCode ^
      privacy.hashCode ^
      photo.hashCode ^
      player.hashCode ^
      manager.hashCode ^
      participants.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
