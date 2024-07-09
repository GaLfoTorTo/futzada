import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:futzada/api/api.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginController{
  final authController = AuthController();
  
  //FUNÇÃO DE LOGIN 
  Future<Map<String, dynamic>>login(String email, String senha) async {
   //BUSCAR URL BASICA
    var url = Uri.parse('${AppApi.url}login');
    //TENTAR SALVAR USUÁRIO
    try {
      //INICIALIZAR REQUISIÇÃO
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
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
        'message':'Erro ao efetuar login.'
      };
    }
  }

  //FUNÇÃO DE LOGIN COM GOOLGE
  Future<void>googleLogin(BuildContext context) async {
    //INICIALIZAR AUTHENTICAÇÃO COM GOOGLE PELO EMAIL
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
    //TENTAR LOGAR
    try {
      //ENVIAR SOLICITAÇÃO AO GOOGLE
      final resp = await googleSignIn.signIn();
      //RESGATAR NOME DE USUÁRIO E FOTO
      final user = UserModel(nome: resp!.displayName!, photo: resp.photoUrl);
      //SALVAR INFORMAÇÕES DO USUÁRIO LOCALMENTE
      authController.setUser(context, user);
    } catch (e) {
      authController.setUser(context, null);
    }
  }
}