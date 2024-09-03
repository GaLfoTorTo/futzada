import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:futzada/api/api.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/casdastro_model.dart';

class CadastroController extends getx.GetxController {
  //INSTANCIA DE CADASTRO MODEL
  CadastroModel model = CadastroModel();
  // CONTROLLERS DE DADOS BASICOS
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobreNomeController = TextEditingController();
  final MaskedTextController userNameController = MaskedTextController(mask: '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', translator: {"@": RegExp(r'[@\w]')});
  final TextEditingController emailController = TextEditingController();
  final MaskedTextController telefoneController = MaskedTextController(mask: "(00) 00000-0000");
  final MaskedTextController dataNascimentoController = MaskedTextController(mask: "00/00/0000");
  final TextEditingController visibilidadeController = TextEditingController();
  final TextEditingController fotoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmacaoController = TextEditingController();
  // CONTROLLERS DE JOGADOR
  final TextEditingController melhorPeController = TextEditingController();
  final TextEditingController arquetipoController = TextEditingController();
  // CONTROLLERS DE TÉNICO
  final TextEditingController equipeController = TextEditingController();
  final TextEditingController siglaController = TextEditingController();
  final TextEditingController primariaController = TextEditingController();
  final TextEditingController secundariaController = TextEditingController();
  final TextEditingController emblemaController = TextEditingController();
  final TextEditingController uniformeController = TextEditingController();

  //VALIDAÇÃO DE CAMPOS
  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }

  //VALIADÇÃO DE CONFIRMAÇÃO DE SENHA
  String? validateConfirm(){
    //VERIFICAR SE NÃO ESTÁ VAZIO
    if(confirmacaoController.text.isEmpty){
      return "Confirmação de Senha deve ser preenchido(a)!";
    }
    //VERIFICAR SE SENHAS COMBINAM
    if(passwordController.text != confirmacaoController.text){
      return "Senha e Confirmação de senha devem ser iguais!";
    }
    return null;
  }

  void onSaved(Map<String, dynamic> updates) {
    model = model.copyWithMap(updates: updates);
  }

  Future<Map<String, dynamic>> sendForm() async {
    //BUSCAR URL BASICA
    var url = AppApi.url+AppApi.createUser;
    //TENTAR SALVAR USUÁRIO
    try {
      //INSTANCIAR DIO
      var dio = Dio();
      //RESGATAR DADOS DE USUARIO NO FORMATO DE MAP
      var formDataMap = model.toMap();
      //CRIAR OBJETO FORMDATA
      var formData = FormData.fromMap(formDataMap);
      //VERIFICAR SE EXISTE FOTO NA REQUISIÇÃO
      if (model.foto != null) {
        //ADICIONAR IMAGEM NO FORMDATA
        formData.files.add(MapEntry(
          'foto',
          await MultipartFile.fromFile(
            model.foto!, 
            filename: model.foto!.split('/').last,
          ),
        ));
      }
      //INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url, 
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
        data: formData,
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
        };
      } else {
        //RESGATAR MENSAGEM DE ERRO
        var errorMessage = jsonDecode(response.data);
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 400,
          'message': errorMessage['message'],
        };
      }
    } on DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }
}
