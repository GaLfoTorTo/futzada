// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  final int? id;
  final String? street;
  final String? number;
  final String? suburb;
  final String? borough;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  AddressModel({
    this.id,
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
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  AddressModel copyWith({
    int? id,
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
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'deletedAt': deletedAt,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] != null ? map['id'] as int : null,
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
      createdAt: map['createdAt'] != null ? map['createdAt'] as DateTime : null,
      updatedAt: map['updatedAt'] != null ? map['updatedAt'] as DateTime : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as DateTime : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) => AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(id: $id, street: $street, number: $number, suburb: $suburb, borough: $borough, city: $city, state: $state, country: $country, zipCode: $zipCode, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
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
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
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
      createdAt.hashCode ^
      updatedAt.hashCode ^
      deletedAt.hashCode;
  }
}
