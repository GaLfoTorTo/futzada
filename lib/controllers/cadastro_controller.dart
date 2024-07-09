import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:futzada/api/api.dart';
import 'package:futzada/models/casdastro_model.dart';
import 'package:http/http.dart' as http;

class CadastroController extends ChangeNotifier {
  CadastroModel model = CadastroModel();

  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }

  void onSaved(Map<String, dynamic> updates) {
    model = model.copyWith(updates: updates);
    notifyListeners();
  }

  Future<Map<String, dynamic>> sendForm() async {
    //BUSCAR URL BASICA
    var url = Uri.parse(AppApi.url+AppApi.createUser);
    //TENTAR SALVAR USUÁRIO
    try {
      //INICIALIZAR REQUISIÇÃO
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(model.toJson()),
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
        };
      } else {
        //RESGATAR MENSAGEM DE ERRO
        var errorMessage = jsonDecode(response.body);
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 400,
          'message': errorMessage['message'],
        };
      }
    } catch (e) {
      //RETORNAR MENSAGEM DE ERRO NO ENVIO DOS DADOS
      return {
        'status': 400,
        'message':'Erro ao registrar o usuário.'
      };
    }
  }
}
