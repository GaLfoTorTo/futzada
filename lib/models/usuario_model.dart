// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UsuarioModel {
  final int? id;
  final String? uuid;
  final String? nome;
  final String? sobrenome;
  final String? userName;
  final String? email;
  final String? dataNascimento;
  final String? telefone;
  final String? visibilidade;
  final String? foto;
  final String? token;

  UsuarioModel({
    this.id,
    this.uuid,
    this.nome,
    this.sobrenome,
    this.userName,
    this.email,
    this.dataNascimento,
    this.telefone,
    this.visibilidade,
    this.foto,
    this.token,
  });

  UsuarioModel copyWith({
    int? id,
    String? uuid,
    String? nome,
    String? sobrenome,
    String? userName,
    String? email,
    String? dataNascimento,
    String? telefone,
    String? visibilidade,
    String? foto,
    String? token,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      nome: nome ?? this.nome,
      sobrenome: sobrenome ?? this.sobrenome,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      telefone: telefone ?? this.telefone,
      visibilidade: visibilidade ?? this.visibilidade,
      foto: foto ?? this.foto,
      token: token ?? this.token,
    );
  }

  UsuarioModel copyWithMap({
    Map<String, dynamic>? updates,
  }) {
    return UsuarioModel(
      id: updates?['id'] ?? this.id,
      uuid: updates?['uuid'] ?? this.uuid,
      nome: updates?['nome'] ?? this.nome,
      sobrenome: updates?['sobrenome'] ?? this.sobrenome,
      userName: updates?['userName'] ?? this.userName,
      email: updates?['email'] ?? this.email,
      dataNascimento: updates?['dataNascimento'] ?? this.dataNascimento,
      telefone: updates?['telefone'] ?? this.telefone,
      visibilidade: updates?['visibilidade'] ?? this.visibilidade,
      foto: updates?['foto'] ?? this.foto,
      token: updates?['token'] ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'uuid': uuid,
      'nome': nome,
      'sobrenome': sobrenome,
      'userName': userName,
      'email': email,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'visibilidade': visibilidade,
      'foto': foto,
      'token': token,
    };
  }

  factory UsuarioModel.fromMap(Map<String, dynamic> map) {
    return UsuarioModel(
      id: map['id'] != null ? map['id'] as int : null,
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      nome: map['nome'] != null ? map['nome'] as String : null,
      sobrenome: map['sobrenome'] != null ? map['sobrenome'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      dataNascimento: map['dataNascimento'] != null ? map['dataNascimento'] as String : null,
      telefone: map['telefone'] != null ? map['telefone'] as String : null,
      visibilidade: map['visibilidade'] != null ? map['visibilidade'] as String : null,
      foto: map['foto'] != null ? map['foto'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UsuarioModel.fromJson(String source) => UsuarioModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UsuarioModel(id: $id, uuid: $uuid, nome: $nome, sobrenome: $sobrenome, userName: $userName, email: $email, dataNascimento: $dataNascimento, telefone: $telefone, visibilidade: $visibilidade, foto: $foto, token: $token)';
  }

  @override
  bool operator ==(covariant UsuarioModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.uuid == uuid &&
      other.nome == nome &&
      other.sobrenome == sobrenome &&
      other.userName == userName &&
      other.email == email &&
      other.dataNascimento == dataNascimento &&
      other.telefone == telefone &&
      other.visibilidade == visibilidade &&
      other.foto == foto &&
      other.token == token;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      uuid.hashCode ^
      nome.hashCode ^
      sobrenome.hashCode ^
      userName.hashCode ^
      email.hashCode ^
      dataNascimento.hashCode ^
      telefone.hashCode ^
      visibilidade.hashCode ^
      foto.hashCode ^
      token.hashCode;
  }
}
