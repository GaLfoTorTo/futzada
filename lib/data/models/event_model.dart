// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/core/enum/enums.dart';
import 'package:futzada/data/models/game_model.dart';
import 'package:futzada/data/models/news_model.dart';
import 'package:futzada/data/models/rule_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/core/utils/date_utils.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/data/models/avaliation_model.dart';
import 'package:futzada/data/models/game_config_model.dart';

class EventModel {
  int? id;
  String? uuid;
  String? title;
  String? bio;
  List<String>? date;
  String? startTime;
  String? endTime;
  Modality? modality;
  bool? collaborators;
  String? photo;
  VisibilityProfile? visibility;
  AddressModel? address;
  GameConfigModel? gameConfig;
  List<UserModel>? participants;
  List<AvaliationModel>? avaliations;
  List<RuleModel>? rules;
  List<NewsModel>? news;
  List<GameModel>? games;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;
  
  EventModel({
    this.id,
    this.uuid,
    this.title,
    this.bio,
    this.date,
    this.startTime,
    this.endTime,
    this.modality,
    this.collaborators,
    this.photo,
    this.address,
    this.gameConfig,
    this.avaliations,
    this.participants,
    this.rules,
    this.news,
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
    List<String>? date,
    String? startTime,
    String? endTime,
    Modality? modality,
    bool? collaborators,
    String? permissions,
    String? photo,
    AddressModel? address,
    GameConfigModel? gameConfig,
    List<AvaliationModel>? avaliations,
    List<UserModel>? participants,
    List<RuleModel>? rules,
    List<NewsModel>? news,
    List<GameModel>? games,
    VisibilityProfile? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return EventModel(
      id: this.id,
      uuid: this.uuid,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      modality: modality ?? this.modality,
      collaborators: collaborators ?? this.collaborators,
      photo: photo ?? this.photo,
      address: address ?? this.address,
      gameConfig: gameConfig ?? this.gameConfig,
      avaliations: avaliations ?? this.avaliations,
      participants: participants ?? this.participants,
      rules: rules ?? this.rules,
      news: news ?? this.news,
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
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'modality': modality,
      'photo': photo,
      'address': address,
      'gameConfig': gameConfig,
      'collaborators': collaborators,
      'avaliations': avaliations,
      'participants': participants!.map((x) => x.toMap()).toList(),
      'rules': rules!.map((x) => x.toMap()).toList(),
      'news': news!.map((x) => x.toMap()).toList(),
      'games': games!.map((x) => x.toMap()).toList(),
      'visibility': visibility,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      date: map['date'] != null ? map['date'] as List<String> : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      modality: map['modality'] != null 
        ? Modality.values.byName(map['modality'])
        : null,
      collaborators: map['collaborators'] != null ? map['collaborators'] as bool : null,
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
        ? List<UserModel>.from((map['participants'] as List<Map<String, dynamic>>).map<UserModel?>((x) => UserModel.fromMap(x),),) 
        : null,
      rules: map['rules'] != null 
        ? List<RuleModel>.from((map['rules'] as List<Map<String, dynamic>>).map<RuleModel?>((x) => RuleModel.fromMap(x),),) 
        : null,
      news: map['news'] != null 
        ? List<NewsModel>.from((map['news'] as List<Map<String, dynamic>>).map<NewsModel?>((x) => NewsModel.fromMap(x),),) 
        : null,
      games: map['games'] != null 
        ? List<GameModel>.from((map['games'] as List<Map<String, dynamic>>).map<GameModel?>((x) => GameModel.fromMap(x),),) 
        : null,
      visibility: map['visibility'] != null
        ? VisibilityProfile.values.firstWhere((e) => e.name == map['visibility'])
        : null,
      createdAt: DatetimeUtils.parseDate(map['createdAt']),
      updatedAt: DatetimeUtils.parseDate(map['updatedAt']),
      deletedAt: DatetimeUtils.parseDate(map['deletedAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, uuid: $uuid, title: $title, bio: $bio, date: $date, startTime: $startTime, endTime: modality: $modality, $endTime, collaborators: $collaborators, photo: $photo, address: $address, gameConfig: $gameConfig, avaliations: $avaliations, participants: $participants, rules: $rules, news: $news, games: $games, visibility: $visibility, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uuid == uuid &&
      other.title == title &&
      other.bio == bio &&
      other.date == date &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.modality == modality &&
      other.collaborators == collaborators &&
      other.photo == photo &&
      other.address == address &&
      other.gameConfig == gameConfig &&
      other.avaliations == avaliations &&
      listEquals(other.participants, participants) &&
      listEquals(other.rules, rules) &&
      listEquals(other.news, news) &&
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
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      modality.hashCode ^
      visibility.hashCode ^
      collaborators.hashCode ^
      photo.hashCode ^
      address.hashCode ^
      gameConfig.hashCode ^
      avaliations.hashCode ^
      participants.hashCode ^
      rules.hashCode ^
      news.hashCode ^
      games.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
