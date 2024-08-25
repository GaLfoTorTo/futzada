import 'dart:convert';

class PeladaModel {
  final String? nome;
  final String? bio;
  final String? visibilidade;
  final String? foto;
  
  PeladaModel({
    this.nome,
    this.bio,
    this.visibilidade,
    this.foto,
  });

  PeladaModel copyWith(
    String? nome,
    String? bio,
    String? visibilidade,
    String? foto,
  ){
    return PeladaModel(
      nome: this.nome,
      bio: this.bio,
      visibilidade: this.visibilidade,
      foto: this.foto,
    );
  }

  PeladaModel copyWithMap({
    Map<String, dynamic>? updates,
  }) {
    return PeladaModel(
      nome: updates?['nome'] ?? this.nome,
      bio: updates?['bio'] ?? this.bio,
      visibilidade: updates?['visibilidade'] ?? this.visibilidade,
      foto: updates?['foto'] ?? this.foto,
    );
  }
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'bio': bio,
      'visibilidade': visibilidade,
      'foto': foto,
    };
  }
}
