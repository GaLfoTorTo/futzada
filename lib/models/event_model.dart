// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/enum/enums.dart';

class EventModel {
  final String? id;
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
  final String? qtdPlayers;
  final VisibilityPerfil? visibility;
  final String? allowCollaborators;
  final String? permissions;
  final String? photo;
  final String? participants;
  
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
    this.participants,
  });


  EventModel copyWith({
    String? id,
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
    String? qtdPlayers,
    VisibilityPerfil? visibility,
    String? allowCollaborators,
    String? permissions,
    String? photo,
    String? participants,
  }) {
    return EventModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
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
      participants: participants ?? this.participants,
    );
  }

  EventModel copyWithMap({
    Map<String, dynamic>? updates,
  }) {
    return EventModel(
      id: updates?['id'] ?? id,
      uuid: updates?['uuid'] ?? uuid,
      title: updates?['title'] ?? title,
      bio: updates?['bio'] ?? bio,
      address: updates?['address'] ?? address,
      number: updates?['number'] ?? number,
      city: updates?['city'] ?? city,
      state: updates?['state'] ?? state,
      complement: updates?['complement'] ?? complement,
      country: updates?['country'] ?? country,
      zipCode: updates?['zipCode'] ?? zipCode,
      daysWeek: updates?['daysWeek'] ?? daysWeek,
      date: updates?['date'] ?? date,
      startTime: updates?['startTime'] ?? startTime,
      endTime: updates?['endTime'] ?? endTime,
      category: updates?['category'] ?? category,
      qtdPlayers: updates?['qtdPlayers'] ?? qtdPlayers,
      visibility: updates?['visibility'] ?? visibility,
      allowCollaborators: updates?['allowCollaborators'] ?? allowCollaborators,
      permissions: updates?['permissions'] ?? permissions,
      photo: updates?['photo'] ?? photo,
      participants: updates?['participants'] ?? participants,
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
      'participants': participants,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] != null ? map['id'] as String : null,
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
      qtdPlayers: map['qtdPlayers'] != null ? map['qtdPlayers'] as String : null,
      visibility: map['visibility'] != null
        ? VisibilityPerfil.values.firstWhere((e) => e.name == map['visibility'])
        : null,
      allowCollaborators: map['allowCollaborators'] != null ? map['allowCollaborators'] as String : null,
      permissions: map['permissions'] != null ? map['permissions'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      participants: map['participants'] != null ? map['participants'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) => EventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'EventModel(id: $id, uuid: $uuid, title: $title, bio: $bio, address: $address, number: $number, city: $city, state: $state, complement: $complement, country: $country, zipCode: $zipCode, daysWeek: $daysWeek, date: $date, startTime: $startTime, endTime: $endTime, category: $category, qtdPlayers: $qtdPlayers, visibility: $visibility, allowCollaborators: $allowCollaborators, permissions: $permissions, photo: $photo, participants: $participants)';
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
      other.participants == participants;
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
      participants.hashCode;
  }
}
