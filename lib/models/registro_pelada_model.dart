// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class RegistroPeladaModel {
  final String? nome;
  final String? bio;
  final String? visibilidade;
  final String? foto;
  final String? colaboradores;
  final String? permissoes;
  final String? endereco;
  final String? diasSemana;
  final String? horaInicio;
  final String? horaFim;
  final String? categoria;
  final String? qtdJogadores;
  final String? convite;
  final String? participantes;
  
  RegistroPeladaModel({
    this.nome,
    this.bio,
    this.visibilidade,
    this.foto,
    this.colaboradores,
    this.permissoes,
    this.endereco,
    this.diasSemana,
    this.horaInicio,
    this.horaFim,
    this.categoria,
    this.qtdJogadores,
    this.convite,
    this.participantes,
  });

  RegistroPeladaModel copyWith({
    String? nome,
    String? bio,
    String? visibilidade,
    String? foto,
    String? colaboradores,
    String? permissoes,
    String? endereco,
    String? diasSemana,
    String? horaInicio,
    String? horaFim,
    String? categoria,
    String? qtdJogadores,
    String? convite,
    String? participantes,
  }) {
    return RegistroPeladaModel(
      nome: nome ?? this.nome,
      bio: bio ?? this.bio,
      visibilidade: visibilidade ?? this.visibilidade,
      foto: foto ?? this.foto,
      colaboradores: colaboradores ?? this.colaboradores,
      permissoes: permissoes ?? this.permissoes,
      endereco: endereco ?? this.endereco,
      diasSemana: diasSemana ?? this.diasSemana,
      horaInicio: horaInicio ?? this.horaInicio,
      horaFim: horaFim ?? this.horaFim,
      categoria: categoria ?? this.categoria,
      qtdJogadores: qtdJogadores ?? this.qtdJogadores,
      convite: convite ?? this.convite,
      participantes: participantes ?? this.participantes,
    );
  }

  RegistroPeladaModel copyWithMap({
    Map<String, dynamic>? updates,
  }) {
    return RegistroPeladaModel(
      nome: updates?['nome'] ?? nome,
      bio: updates?['bio'] ?? bio,
      visibilidade: updates?['visibilidade'] ?? visibilidade,
      foto: updates?['foto'] ?? foto,
      colaboradores: updates?['colaboradores'] ?? colaboradores,
      permissoes: updates?['permissoes'] ?? permissoes,
      endereco: updates?['endereco'] ?? endereco,
      diasSemana: updates?['diasSemana'] ?? diasSemana,
      horaInicio: updates?['horaInicio'] ?? horaInicio,
      horaFim: updates?['horaFim'] ?? horaFim,
      categoria: updates?['categoria'] ?? categoria,
      qtdJogadores: updates?['qtdJogadores'] ?? qtdJogadores,
      convite: updates?['convite'] ?? convite,
      participantes: updates?['participantes'] ?? participantes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'bio': bio,
      'visibilidade': visibilidade,
      'foto': foto,
      'colaboradores': colaboradores,
      'permissoes': permissoes,
      'endereco': endereco,
      'diasSemana': diasSemana,
      'horaInicio': horaInicio,
      'horaFim': horaFim,
      'categoria': categoria,
      'qtdJogadores': qtdJogadores,
      'convite': convite,
      'participantes': participantes,
    };
  }

  factory RegistroPeladaModel.fromMap(Map<String, dynamic> map) {
    return RegistroPeladaModel(
      nome: map['nome'] != null ? map['nome'] as String : null,
      bio: map['bio'] != null ? map['bio'] as String : null,
      visibilidade: map['visibilidade'] != null ? map['visibilidade'] as String : null,
      foto: map['foto'] != null ? map['foto'] as String : null,
      colaboradores: map['colaboradores'] != null ? map['colaboradores'] as String : null,
      permissoes: map['permissoes'] != null ? map['permissoes'] as String : null,
      endereco: map['endereco'] != null ? map['endereco'] as String : null,
      diasSemana: map['diasSemana'] != null ? map['diasSemana'] as String : null,
      horaInicio: map['horaInicio'] != null ? map['horaInicio'] as String : null,
      horaFim: map['horaFim'] != null ? map['horaFim'] as String : null,
      categoria: map['categoria'] != null ? map['categoria'] as String : null,
      qtdJogadores: map['qtdJogadores'] != null ? map['qtdJogadores'] as String : null,
      convite: map['convite'] != null ? map['convite'] as String : null,
      participantes: map['participantes'] != null ? map['participantes'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RegistroPeladaModel.fromJson(String source) => RegistroPeladaModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RegistroPeladaModel(nome: $nome, bio: $bio, visibilidade: $visibilidade, foto: $foto, colaboradores: $colaboradores, permissoes: $permissoes, endereco: $endereco, diasSemana: $diasSemana, horaInicio: $horaInicio, horaFim: $horaFim, categoria: $categoria, qtdJogadores: $qtdJogadores, convite: $convite, participantes: $participantes)';
  }

  @override
  bool operator ==(covariant RegistroPeladaModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.nome == nome &&
      other.bio == bio &&
      other.visibilidade == visibilidade &&
      other.foto == foto &&
      other.colaboradores == colaboradores &&
      other.permissoes == permissoes &&
      other.endereco == endereco &&
      other.diasSemana == diasSemana &&
      other.horaInicio == horaInicio &&
      other.horaFim == horaFim &&
      other.categoria == categoria &&
      other.qtdJogadores == qtdJogadores &&
      other.convite == convite &&
      other.participantes == participantes;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
      bio.hashCode ^
      visibilidade.hashCode ^
      foto.hashCode ^
      colaboradores.hashCode ^
      permissoes.hashCode ^
      endereco.hashCode ^
      diasSemana.hashCode ^
      horaInicio.hashCode ^
      horaFim.hashCode ^
      categoria.hashCode ^
      qtdJogadores.hashCode ^
      convite.hashCode ^
      participantes.hashCode;
  }
}
