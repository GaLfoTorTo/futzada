//===MIXIN - RULES===
import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';

mixin EventRulesMixin on GetxController{
  //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
  late TextEditingController ruleTitleController;
  late QuillController ruleDescriptionController;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS
  void initRuleTextControllers(Map<String, String?> values) {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    ruleTitleController = TextEditingController(text: values['title']);
    ruleDescriptionController = QuillController(
      document: Document()..insert(0, values['description'] ?? ''),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }
  
  void disposeRuleTextControllers() {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    ruleTitleController.dispose();
    ruleDescriptionController.dispose();
  }
}