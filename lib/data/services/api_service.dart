import 'dart:convert';
import 'package:dio/dio.dart'as Dio;
import 'package:get_storage/get_storage.dart';
import 'package:futzada/core/helpers/app_helper.dart';

class ApiService {
  //FUNÇÃO DE VALIDAÇÃO DE CAMPOS
  String? validateEmpty(String? value, String label) => (value?.isEmpty ?? true) ? "$label deve ser preenchido(a)!" : null;
  
  //FUNÇÃO DE ENVIO DE FORMULÁRIO (COM IMAGENS NA REQUISIÇÃO)
  static Future<Map<String, dynamic>> post(Map<String, dynamic> dataForm, String url) async {
    //TENTAR ENVIAR DADOS
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //DEFINIR OPÇÕES DE REQUISIÇÃO
      final options = await setOption();
      //CRIAR OBJETO FORMDATA
      var formData = Dio.FormData.fromMap(dataForm);
      //VERIFICAR SE EXISTE FOTO NA REQUISIÇÃO
      if(dataForm.containsKey('photo') || dataForm.containsKey('photos')) {
        //ADICIONAR IMAGEM NO FORMDATA
        formData.files.add(MapEntry(
          'photo',
          await Dio.MultipartFile.fromFile(
            dataForm["photo"],
            filename: dataForm["photo"].split('/').last,
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
  
  //FUNÇÃO DE BUSCA DE DADOS
  Future<Map<String, dynamic>> get(String url) async {
    //TENTAR BUSCAR DADOS
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //DEFINIR OPÇÕES DE REQUISIÇÃO
      final options = await setOption();
      //INICIALIZAR REQUISIÇÃO
      var response = await dio.get(
        url, 
        options: Dio.Options(headers: options),
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200) {
        //RETORNAR DADOS
        return {
          'status': 200,
          'data': response.data,
        };
      } else {
        //RETORNAR VAZIO
        return {
          'status': 400,
          'data' : null
        };
      }
    } on Dio.DioException catch (e) {
      //TRATAR ERROS
      return AppHelper.tratamentoErros(e);
    }
  }

  //FUNÇÃO DE CONFIGURAÇÕES DE HEADERS DE REQUISIÇÃO
  static Future<Map<String, dynamic>>setOption() async {
    //DEFINIR HEADER PADRÃO
    var header = {'Content-Type': 'application/json'};
    //VERIFICAR SE EXISTE TOKEN NO DISPOSITIVO
    final String? token = GetStorage().read('token');
    //ADICIONAR TOKEN JWT
    if(token != null) header['Authorization'] = 'Bearer $token';
    return header;
  }
}