// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/models/game_config_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/participant_model.dart';

class EventModel {
  int? id;
  String? uuid;
  String? title;
  String? bio;
  String? daysWeek;
  String? date;
  String? startTime;
  String? endTime;
  String? category;
  bool? allowCollaborators;
  String? permissions;
  String? photo;
  AddressModel? address;
  GameConfigModel? gameConfig;
  List<ParticipantModel>? participants;
  List<AvaliationModel>? avaliations;
  List<GameModel>? games;
  VisibilityPerfil? visibility;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  
  EventModel({
    this.id,
    this.uuid,
    this.title,
    this.bio,
    this.daysWeek,
    this.date,
    this.startTime,
    this.endTime,
    this.category,
    this.allowCollaborators,
    this.permissions,
    this.photo,
    this.address,
    this.gameConfig,
    this.avaliations,
    this.participants,
    this.games,
    this.visibility,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  EventModel copyWith({
    int? id,
    String? uuid,
    String? title,
    String? bio,
    String? daysWeek,
    String? date,
    String? startTime,
    String? endTime,
    String? category,
    bool? allowCollaborators,
    String? permissions,
    String? photo,
    AddressModel? address,
    GameConfigModel? gameConfig,
    List<AvaliationModel>? avaliations,
    List<ParticipantModel>? participants,
    List<GameModel>? games,
    VisibilityPerfil? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return EventModel(
      id: this.id,
      uuid: this.uuid,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      daysWeek: daysWeek ?? this.daysWeek,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      allowCollaborators: allowCollaborators ?? this.allowCollaborators,
      permissions: permissions ?? this.permissions,
      photo: photo ?? this.photo,
      address: address ?? this.address,
      gameConfig: gameConfig ?? this.gameConfig,
      avaliations: avaliations ?? this.avaliations,
      participants: participants ?? this.participants,
      games: games ?? this.games,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'title': title,
      'bio': bio,
      'daysWeek': daysWeek,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
      'photo': photo,
      'address': address,
      'gameConfig': gameConfig,
      'allowCollaborators': allowCollaborators,
      'permissions': permissions,
      'avaliations': avaliations,
      'participants': participants!.map((x) => x.toMap()).toList(),
      'games': games!.map((x) => x.toMap()).toList(),
      'visibility': visibility,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      daysWeek: map['daysWeek'] != null ? map['daysWeek'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      allowCollaborators: map['allowCollaborators'] != null ? map['allowCollaborators'] as bool : null,
      permissions: map['permissions'] != null ? map['permissions'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      address: map['address'] != null 
        ? AddressModel.fromMap(map['address'] as Map<String,dynamic>) 
        : null,
      gameConfig: map['gameConfig'] != null 
        ? GameConfigModel.fromMap(map['gameConfig'] as Map<String,dynamic>) 
        : null,
      avaliations: map['avaliations'] != null 
        ? List<AvaliationModel>.from((map['avaliations'] as List<Map<String, dynamic>>).map<AvaliationModel?>((x) => AvaliationModel.fromMap(x),),) 
        : null,
      participants: map['participants'] != null 
        ? List<ParticipantModel>.from((map['participants'] as List<Map<String, dynamic>>).map<ParticipantModel?>((x) => ParticipantModel.fromMap(x),),) 
        : null,
      games: map['games'] != null 
        ? List<GameModel>.from((map['games'] as List<Map<String, dynamic>>).map<GameModel?>((x) => GameModel.fromMap(x),),) 
        : null,
      visibility: map['visibility'] != null
        ? VisibilityPerfil.values.firstWhere((e) => e.name == map['visibility'])
        : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, uuid: $uuid, title: $title, bio: $bio, daysWeek: $daysWeek, date: $date, startTime: $startTime, endTime: $endTime, category: $category, allowCollaborators: $allowCollaborators, permissions: $permissions, photo: $photo, address: $address, gameConfig: $gameConfig, avaliations: $avaliations, participants: $participants, games: $games, visibility: $visibility, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uuid == uuid &&
      other.title == title &&
      other.bio == bio &&
      other.daysWeek == daysWeek &&
      other.date == date &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.category == category &&
      other.allowCollaborators == allowCollaborators &&
      other.permissions == permissions &&
      other.photo == photo &&
      other.address == address &&
      other.gameConfig == gameConfig &&
      other.avaliations == avaliations &&
      listEquals(other.participants, participants) &&
      listEquals(other.games, games) &&
      other.visibility == visibility &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uuid.hashCode ^
      title.hashCode ^
      bio.hashCode ^
      daysWeek.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      category.hashCode ^
      visibility.hashCode ^
      allowCollaborators.hashCode ^
      permissions.hashCode ^
      photo.hashCode ^
      address.hashCode ^
      gameConfig.hashCode ^
      avaliations.hashCode ^
      participants.hashCode ^
      games.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
