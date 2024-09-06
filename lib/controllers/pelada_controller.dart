import 'dart:convert';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/api/api.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/pelada_model.dart';

class PeladaController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETX
  static PeladaController get instace => Get.find();
  //INSTANCIA DE PELADA MODEL
  PeladaModel model = PeladaModel();
  // CONTROLLERS DE CADA CAMPO
  late final TextEditingController nomeController = TextEditingController();
  late final TextEditingController bioController = TextEditingController();
  late final TextEditingController visibilidadeController = TextEditingController();
  late final TextEditingController fotoController = TextEditingController();
  late final TextEditingController enderecoController = TextEditingController();
  late final TextEditingController categoriaController = TextEditingController();
  late final TextEditingController diasSemanaController = TextEditingController();
  late final TextEditingController dataController = MaskedTextController(mask: "00/00/0000");
  //CONTROLLER DE POSIÇÕES
  final List<dynamic> diasSemana = [];

  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }

  void onSaved(Map<String, dynamic> updates) {
    model = model.copyWithMap(updates: updates);
    notifyListeners();
  }

  Future<Map<String, dynamic>> sendForm() async {
    //BUSCAR URL BASICA
    var url = AppApi.url+AppApi.createUser;
    //TENTAR SALVAR USUÁRIO
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //RESGATAR DADOS DE USUARIO NO FORMATO DE MAP
      var formDataMap = model.toMap();
      //CRIAR OBJETO FORMDATA
      var formData = Dio.FormData.fromMap(formDataMap);
      //VERIFICAR SE EXISTE FOTO NA REQUISIÇÃO
      if (model.foto != null) {
        //ADICIONAR IMAGEM NO FORMDATA
        formData.files.add(MapEntry(
          'foto',
          await Dio.MultipartFile.fromFile(
            model.foto!, 
            filename: model.foto!.split('/').last,
          ),
        ));
      }
      //INICIALIZAR REQUISIÇÃO
      var response = await dio.post(
        url, 
        options: Dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
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
}
