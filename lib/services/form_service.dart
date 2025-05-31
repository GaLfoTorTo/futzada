import 'dart:convert';

import 'package:dio/dio.dart'as Dio;
import 'package:futzada/helpers/app_helper.dart';

class FormService {
  //FUNÇÃO DE ENVIO DE FORMULÁRIO (COM IMAGENS NA REQUISIÇÃO)
  static Future<Map<String, dynamic>> sendForm(model, options, url) async {
    //TENTAR ENVIAR DADOS
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //RESGATAR DADOS DE USUARIO NO FORMATO DE MAP
      var formDataMap = model.toMap();
      //CRIAR OBJETO FORMDATA
      var formData = Dio.FormData.fromMap(formDataMap);
      //VERIFICAR SE EXISTE FOTO NA REQUISIÇÃO
      if (model.photo != null) {
        //ADICIONAR IMAGEM NO FORMDATA
        formData.files.add(MapEntry(
          'photo',
          await Dio.MultipartFile.fromFile(
            model.photo!, 
            filename: model.photo!.split('/').last,
          ),
        ));
      }
      //INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url, 
        options: Dio.Options(headers: options),
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
    } on Dio.DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }

  //FUNÇÃO DE ENVIO DE FORMULÁRIO
  static Future<Map<String, dynamic>> sendData(data, options, url) async {
    //TENTAR ENVIAR DADOS
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url, 
        options: Dio.Options(headers: options),
        data: data,
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RETORNAR MENSAGEM DE SUCESSO NO SALVAMENTO
        return {
          'status': 200,
          'data': response.data,
        };
      } else {
        //RETORNAR MENSAGEM DE ERRO NO SALVAMENTO
        return {
          'status': 400,
          'message': response.data
        };
      }
    } on Dio.DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }

  //FUNÇÃO DE CONFIGURAÇÕES DE HEADERS 
  static Future<Map<String, dynamic>>setOption(user) async {
    //VERIFICAR SE USARIO ESTA LOGADO
    if(user != null){
      return {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${user.token}'
            };
    }else{
      return {'Content-Type': 'application/json'};
    }
  }
}