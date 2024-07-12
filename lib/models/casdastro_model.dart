// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CadastroModel {
  final String? nome;
  final String? sobrenome;
  final String? userName;
  final String? email;
  final String? dataNascimento;
  final String? telefone;
  final String? visibilidade;
  final String? foto;
  final String? password;
  final String? confirmacao;
  final String? equipe;
  final String? sigla;
  final String? primaria;
  final String? secundaria;
  final String? emblema;
  final String? uniforme;
  final String? posicoes;
  final String? melhorPe;
  final String? arquetipo;
  
  CadastroModel({
    this.nome,
    this.sobrenome,
    this.userName,
    this.email,
    this.dataNascimento,
    this.telefone,
    this.visibilidade,
    this.foto,
    this.password, 
    this.confirmacao, 
    this.equipe,
    this.sigla,
    this.primaria,
    this.secundaria,
    this.emblema,
    this.uniforme,
    this.posicoes,
    this.melhorPe,
    this.arquetipo,
  });

  CadastroModel copyWith({
    Map<String, dynamic>? updates,
  }) {
    return CadastroModel(
      nome: updates?['nome'] ?? this.nome,
      sobrenome: updates?['sobrenome'] ?? this.sobrenome,
      userName: updates?['userName'] ?? this.userName,
      email: updates?['email'] ?? this.email,
      dataNascimento: updates?['dataNascimento'] ?? this.dataNascimento,
      telefone: updates?['telefone'] ?? this.telefone,
      visibilidade: updates?['visibilidade'] ?? this.visibilidade,
      foto: updates?['foto'] ?? this.foto,
      password: updates?['password'] ?? this.password,
      confirmacao: updates?['confirmacao'] ?? this.confirmacao,
      equipe: updates?['equipe'] ?? this.equipe,
      sigla: updates?['sigla'] ?? this.sigla,
      primaria: updates?['primaria'] ?? this.primaria,
      secundaria: updates?['secundaria'] ?? this.secundaria,
      emblema: updates?['emblema'] ?? this.emblema,
      uniforme: updates?['uniforme'] ?? this.uniforme,
      posicoes: updates?['posicoes'] ?? this.posicoes,
      melhorPe: updates?['melhorPe'] ?? this.melhorPe,
      arquetipo: updates?['arquetipo'] ?? this.arquetipo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'sobrenome': sobrenome,
      'userName': userName,
      'email': email,
      'dataNascimento': dataNascimento,
      'telefone': telefone,
      'visibilidade': visibilidade,
      'foto': foto,
      'password': password,
      'confirmacao': confirmacao,
      'equipe': equipe,
      'sigla': sigla,
      'primaria': primaria,
      'secundaria': secundaria,
      'emblema': emblema,
      'uniforme': uniforme,
      'posicoes': posicoes,
      'melhorPe': melhorPe,
      'arquetipo': arquetipo,
    };
  }

  factory CadastroModel.fromMap(Map<String, dynamic> map) {
    return CadastroModel(
      nome: map['nome'] != null ? map['nome'] as String : null,
      sobrenome: map['sobrenome'] != null ? map['sobrenome'] as String : null,
      userName: map['userName'] != null ? map['userName'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      dataNascimento: map['dataNascimento'] != null ? map['dataNascimento'] as String : null,
      telefone: map['telefone'] != null ? map['telefone'] as String : null,
      visibilidade: map['visibilidade'] != null ? map['visibilidade'] as String : null,
      foto: map['foto'] != null ? map['foto'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      confirmacao: map['confirmacao'] != null ? map['confirmacao'] as String : null,
      equipe: map['equipe'] != null ? map['equipe'] as String : null,
      sigla: map['sigla'] != null ? map['sigla'] as String : null,
      primaria: map['primaria'] != null ? map['primaria'] as String : null,
      secundaria: map['secundaria'] != null ? map['secundaria'] as String : null,
      emblema: map['emblema'] != null ? map['emblema'] as String : null,
      uniforme: map['uniforme'] != null ? map['uniforme'] as String : null,
      posicoes: map['posicoes'] != null ? map['posicoes'] as String : null,
      melhorPe: map['melhorPe'] != null ? map['melhorPe'] as String : null,
      arquetipo: map['arquetipo'] != null ? map['arquetipo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CadastroModel.fromJson(String source) => CadastroModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CadastroModel(nome: $nome, sobrenome: $sobrenome, userName: $userName, email: $email, dataNascimento: $dataNascimento, telefone: $telefone, visibilidade: $visibilidade, foto: $foto, password: $password, confirmacao: $confirmacao, equipe: $equipe, sigla: $sigla, primaria: $primaria, secundaria: $secundaria, emblema: $emblema, uniforme: $uniforme, posicoes: $posicoes, melhorPe: $melhorPe, arquetipo: $arquetipo)';
  }

  @override
  bool operator ==(covariant CadastroModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.nome == nome &&
      other.sobrenome == sobrenome &&
      other.userName == userName &&
      other.email == email &&
      other.dataNascimento == dataNascimento &&
      other.telefone == telefone &&
      other.visibilidade == visibilidade &&
      other.foto == foto &&
      other.password == password &&
      other.confirmacao == confirmacao &&
      other.equipe == equipe &&
      other.sigla == sigla &&
      other.primaria == primaria &&
      other.secundaria == secundaria &&
      other.emblema == emblema &&
      other.uniforme == uniforme &&
      other.posicoes == posicoes &&
      other.melhorPe == melhorPe &&
      other.arquetipo == arquetipo;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
      sobrenome.hashCode ^
      userName.hashCode ^
      email.hashCode ^
      dataNascimento.hashCode ^
      telefone.hashCode ^
      visibilidade.hashCode ^
      foto.hashCode ^
      password.hashCode ^
      confirmacao.hashCode ^
      equipe.hashCode ^
      sigla.hashCode ^
      primaria.hashCode ^
      secundaria.hashCode ^
      emblema.hashCode ^
      uniforme.hashCode ^
      posicoes.hashCode ^
      melhorPe.hashCode ^
      arquetipo.hashCode;
  }
}
