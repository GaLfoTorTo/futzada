// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:futzada/core/helpers/date_helper.dart';

class AddressModel {
  int? id;
  int? eventId;
  String? street;
  String? number;
  String? suburb;
  String? borough;
  String? city;
  String? state;
  String? country;
  String? zipCode;
  double? latitude;
  double? longitude;
  List<String>? photos;
  DateTime? createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  AddressModel({
    this.id,
    this.eventId,
    this.street,
    this.number,
    this.suburb,
    this.borough,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.photos,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  AddressModel copyWith({
    int? id,
    int? eventId,
    String? street,
    String? number,
    String? suburb,
    String? borough,
    String? city,
    String? state,
    String? country,
    String? zipCode,
    double? latitude,
    double? longitude,
    List<String>? photos,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      street: street ?? this.street,
      number: number ?? this.number,
      suburb: suburb ?? this.suburb,
      borough: borough ?? this.borough,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      zipCode: zipCode ?? this.zipCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      photos: photos ?? this.photos,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventId': eventId,
      'street': street,
      'number': number,
      'suburb': suburb,
      'borough': borough,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'latitude': latitude,
      'longitude': longitude,
      'photos': photos,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] as int,
      eventId: map['eventId'] as int,
      street: map['street'] != null ? map['street'] as String : null,
      number: map['number'] != null ? map['number'] as String : null,
      suburb: map['suburb'] != null ? map['suburb'] as String : null,
      borough: map['borough'] != null ? map['borough'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      state: map['state'] != null ? map['state'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      zipCode: map['zipCode'] != null ? map['zipCode'] as String : null,
      latitude: map['latitude'] != null ? map['latitude'] as double : null,
      longitude: map['longitude'] != null ? map['longitude'] as double : null,
      photos: map['photos'] != null ? map['photos'] as List<String> : null,
      createdAt: DateHelper.parseDate(map['createdAt']),
      updatedAt:  DateHelper.parseDate(map['updatedAt']),
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) => AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(id: $id, eventId: $eventId, street: $street, number: $number, suburb: $suburb, borough: $borough, city: $city, state: $state, country: $country, zipCode: $zipCode, latitude: $latitude, longitude: $longitude, photos: $photos, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventId == eventId &&
      other.street == street &&
      other.number == number &&
      other.suburb == suburb &&
      other.borough == borough &&
      other.city == city &&
      other.state == state &&
      other.country == country &&
      other.zipCode == zipCode &&
      other.latitude == latitude &&
      other.longitude == longitude &&
      other.photos == photos &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return 
      id.hashCode ^
      eventId.hashCode ^
      street.hashCode ^
      number.hashCode ^
      suburb.hashCode ^
      borough.hashCode ^
      city.hashCode ^
      state.hashCode ^
      country.hashCode ^
      zipCode.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      photos.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
