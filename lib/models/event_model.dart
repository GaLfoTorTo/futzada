// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:futzada/enum/enums.dart';
import 'package:futzada/models/avaliation_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/participant_model.dart';

class EventModel {
  final int? id;
  final String? uuid;
  final String? title;
  final String? bio;
  final String? address;
  final String? number;
  final String? city;
  final String? state;
  final String? complement;
  final String? country;
  final String? zipCode;
  final String? daysWeek;
  final String? date;
  final String? startTime;
  final String? endTime;
  final String? category;
  final int? qtdPlayers;
  final VisibilityPerfil? visibility;
  final bool? allowCollaborators;
  final String? permissions;
  final String? photo;
  final List<ParticipantModel>? participants;
  final List<AvaliationModel>? avaliations;
  final List<GameModel>? games;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  
  EventModel({
    this.id,
    this.uuid,
    this.title,
    this.bio,
    this.address,
    this.number,
    this.city,
    this.state,
    this.complement,
    this.country,
    this.zipCode,
    this.daysWeek,
    this.date,
    this.startTime,
    this.endTime,
    this.category,
    this.qtdPlayers,
    this.visibility,
    this.allowCollaborators,
    this.permissions,
    this.photo,
    this.avaliations,
    this.participants,
    this.games,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  EventModel copyWith({
    int? id,
    String? uuid,
    String? title,
    String? bio,
    String? address,
    String? number,
    String? city,
    String? state,
    String? complement,
    String? country,
    String? zipCode,
    String? daysWeek,
    String? date,
    String? startTime,
    String? endTime,
    String? category,
    int? qtdPlayers,
    VisibilityPerfil? visibility,
    bool? allowCollaborators,
    String? permissions,
    String? photo,
    List<AvaliationModel>? avaliations,
    List<ParticipantModel>? participants,
    List<GameModel>? games,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    return EventModel(
      id: this.id,
      uuid: this.uuid,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      number: number ?? this.number,
      city: city ?? this.city,
      state: state ?? this.state,
      complement: complement ?? this.complement,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      daysWeek: daysWeek ?? this.daysWeek,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      category: category ?? this.category,
      qtdPlayers: qtdPlayers ?? this.qtdPlayers,
      visibility: visibility ?? this.visibility,
      allowCollaborators: allowCollaborators ?? this.allowCollaborators,
      permissions: permissions ?? this.permissions,
      photo: photo ?? this.photo,
      avaliations: avaliations ?? this.avaliations,
      participants: participants ?? this.participants,
      games: games ?? this.games,
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
      'address': address,
      'number': number,
      'city': city,
      'state': state,
      'complement': complement,
      'country': country,
      'zipCode': zipCode,
      'daysWeek': daysWeek,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'category': category,
      'qtdPlayers': qtdPlayers,
      'visibility': visibility,
      'allowCollaborators': allowCollaborators,
      'permissions': permissions,
      'photo': photo,
      'avaliations': avaliations,
      'participants': participants!.map((x) => x.toMap()).toList(),
      'games': games!.map((x) => x.toMap()).toList(),
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
      address: map['address'] != null ? map['address'] as String : null,
      number: map['number'] != null ? map['number'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      complement: map['complement'] != null ? map['complement'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      zipCode: map['zipCode'] != null ? map['zipCode'] as String : null,
      daysWeek: map['daysWeek'] != null ? map['daysWeek'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      endTime: map['endTime'] != null ? map['endTime'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      qtdPlayers: map['qtdPlayers'] != null ? map['qtdPlayers'] as int : null,
      visibility: map['visibility'] != null
        ? VisibilityPerfil.values.firstWhere((e) => e.name == map['visibility'])
        : null,
      allowCollaborators: map['allowCollaborators'] != null ? map['allowCollaborators'] as bool : null,
      permissions: map['permissions'] != null ? map['permissions'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      avaliations: map['avaliations'] != null 
        ? List<AvaliationModel>.from((map['avaliations'] as List<Map<String, dynamic>>).map<AvaliationModel?>((x) => AvaliationModel.fromMap(x),),) 
        : null,
      participants: map['participants'] != null 
        ? List<ParticipantModel>.from((map['participants'] as List<Map<String, dynamic>>).map<ParticipantModel?>((x) => ParticipantModel.fromMap(x),),) 
        : null,
      games: map['games'] != null 
        ? List<GameModel>.from((map['games'] as List<Map<String, dynamic>>).map<GameModel?>((x) => GameModel.fromMap(x),),) 
        : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, uuid: $uuid, title: $title, bio: $bio, address: $address, number: $number, city: $city, state: $state, complement: $complement, country: $country, zipCode: $zipCode, daysWeek: $daysWeek, date: $date, startTime: $startTime, endTime: $endTime, category: $category, qtdPlayers: $qtdPlayers, visibility: $visibility, allowCollaborators: $allowCollaborators, permissions: $permissions, photo: $photo, avaliations: $avaliations, participants: $participants, games: $games, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant EventModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uuid == uuid &&
      other.title == title &&
      other.bio == bio &&
      other.address == address &&
      other.number == number &&
      other.city == city &&
      other.state == state &&
      other.complement == complement &&
      other.country == country &&
      other.zipCode == zipCode &&
      other.daysWeek == daysWeek &&
      other.date == date &&
      other.startTime == startTime &&
      other.endTime == endTime &&
      other.category == category &&
      other.qtdPlayers == qtdPlayers &&
      other.visibility == visibility &&
      other.allowCollaborators == allowCollaborators &&
      other.permissions == permissions &&
      other.photo == photo &&
      other.avaliations == avaliations &&
      listEquals(other.participants, participants) &&
      listEquals(other.games, games) &&
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
      address.hashCode ^
      number.hashCode ^
      city.hashCode ^
      state.hashCode ^
      complement.hashCode ^
      country.hashCode ^
      zipCode.hashCode ^
      daysWeek.hashCode ^
      date.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      category.hashCode ^
      qtdPlayers.hashCode ^
      visibility.hashCode ^
      allowCollaborators.hashCode ^
      permissions.hashCode ^
      photo.hashCode ^
      avaliations.hashCode ^
      participants.hashCode ^
      games.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
