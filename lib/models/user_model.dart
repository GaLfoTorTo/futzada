import 'dart:convert';

class UserModel {
  final String nome;
  final String? photo;

  UserModel({
    required this.nome,
    required this.photo,
  });

  factory UserModel.fromMap(Map<String, dynamic> map){
    return UserModel(
      nome: map['nome'], 
      photo: map['photo']
    );
  }
  
  factory UserModel.fromJson(String json) => UserModel.fromMap(jsonDecode(json));

  Map<String, dynamic>toMap() => {
    "nome": nome,
    "photo": photo
  };

  String toJson()=> jsonEncode(toMap());
}