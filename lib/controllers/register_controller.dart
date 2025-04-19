import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/services/form_service.dart';
import 'package:get/get.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class RegisterController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static RegisterController get instace => Get.find();
  //INSTANCIAR MODEL DE USUARIO
  UserModel model = UserModel();
  // CONTROLLERS DE DADOS BASICOS
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final MaskedTextController userNameController = MaskedTextController(mask: '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', translator: {"@": RegExp(r'[@\w]')});
  final TextEditingController emailController = TextEditingController();
  final MaskedTextController phoneController = MaskedTextController(mask: "(00) 00000-0000");
  final MaskedTextController bornDateController = MaskedTextController(mask: "00/00/0000");
  final TextEditingController visibilityController = TextEditingController();
  final TextEditingController photoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // CONTROLLERS DE JOGADOR
  final TextEditingController bestSideController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  // CONTROLLERS DE TÉNICO
  final TextEditingController teamController = TextEditingController();
  final TextEditingController aliasController = TextEditingController();
  final TextEditingController primaryController = TextEditingController();
  final TextEditingController secondaryController = TextEditingController();
  final TextEditingController emblemController = TextEditingController();
  final TextEditingController uniformController = TextEditingController();

  //VALIDAÇÃO DE CAMPOS
  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }

  void onSaved(Map<String, dynamic> updates) {
    model = model.copyWithMap(updates: updates);
  }

  Future<Map<String, dynamic>> registerUser() async {
    //BUSCAR URL BASICA
    var url = AppApi.url+AppApi.createUser;
    //RESGATAR OPTIONS
    var options = await FormService.setOption(null);
    //ENVIAR FORMULÁRIO
    var response = await FormService.sendForm(model, options, url);
    return response;
  }
}
