import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/api/api.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/player_model.dart';
import 'package:futzada/data/models/manager_model.dart';
import 'package:futzada/data/services/api_service.dart';
import 'package:futzada/presentation/widget/overlays/form_overlay_widget.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class RegisterController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static RegisterController get instance => Get.find();
  //DEFINIR FORMDATA
  Map<String, dynamic> formData = {};
  //DEFINIÇÃO EXTRAS DO USUARIO
  ManagerModel manager = ManagerModel();
  PlayerModel player = PlayerModel();
  //CONTROLE DE STEP
  RxInt step = 0.obs;
  // VARIÁVEL PARA CONTROLAR O STATUS
  RxInt submitStatus = 0.obs;
  //CONTROLADORES DE ATUAÇÃO - PLAYER, MANAGER
  bool playerChecked = false;
  bool managerChecked = false;
  //CONTROLLADORES DE CHECKBOX
  bool termosUsoChecked = false;
  bool politicasChecked = false;
  bool saveEnable = false;
  String? errorMessage;

  //CONTROLLERS DE TEXTO
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late MaskedTextController userNameController;
  late TextEditingController emailController;
  late MaskedTextController phoneController;
  late MaskedTextController bornDateController;
  late TextEditingController visibilityController;
  late TextEditingController passwordController;
  late TextEditingController photoController;
  late TextEditingController mainModalityController;
  late TextEditingController modalityController;
  //PLAYER
  late TextEditingController bestSideController;
  late TextEditingController mainPositionController;
  late TextEditingController positionsController;
  late TextEditingController typeController;
  //MANAGER
  late TextEditingController teamController;
  late TextEditingController aliasController;
  late TextEditingController primaryController;
  late TextEditingController secondaryController;
  late TextEditingController emblemController;
  late TextEditingController uniformController;
  //ESTADOS - PLAYER
  RxList<String> modalities = <String>[].obs;
  RxList<String> positions = <String>[].obs;
  RxMap<String, String> mainPositions = <String, String>{
    "Football": "",
    "Volleyball": "",
    "Basketball": "",
  }.obs;
  //ESTADOS - MANAGER
  String emblem = "emblema_1";
  Map<String, Map<String, dynamic>>? configEmblem;
  Map<String, Map<String, dynamic>>? configUniform;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS DE TEXTO
  @override
  void onInit(){
    super.onInit();
    //INICIALIZAR CONTROLLERS DE TEXTO
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    userNameController = MaskedTextController(mask: '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', translator: {"@": RegExp(r'[@\w]')});
    emailController = TextEditingController();
    phoneController = MaskedTextController(mask: "(00) 00000-0000");
    bornDateController = MaskedTextController(mask: "00/00/0000");
    visibilityController = TextEditingController();
    passwordController = TextEditingController();
    photoController = TextEditingController();
    //PLAYER
    mainModalityController = TextEditingController();
    modalityController = TextEditingController();
    bestSideController = TextEditingController();
    mainPositionController = TextEditingController();
    positionsController = TextEditingController();
    typeController = TextEditingController();
    //MANAGER
    teamController = TextEditingController();
    aliasController = TextEditingController();
    primaryController = TextEditingController();
    secondaryController = TextEditingController();
    emblemController = TextEditingController();
    uniformController = TextEditingController();
  }

  //FUNÇÃO PARA FINALIZAR CONTROLLERS DE TEXTO
  @override
  void onClose(){
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bornDateController.dispose();
    visibilityController.dispose();
    passwordController.dispose();
    photoController.dispose();
    bestSideController.dispose();
    typeController.dispose();
    teamController.dispose();
    aliasController.dispose();
    primaryController.dispose();
    secondaryController.dispose();
    emblemController.dispose();
    uniformController.dispose();
    //ENCERRAR CONTROLLER
    super.onClose();
  }
  
  //FUNÇÃO DE PROXIMO STEP
  void nextStep() {
    if(step.value < 3){
      step.value = step.value + 1;
    }
    switch (step.value) {
      case 0:
        //formKeyStep1.currentState!.validate();
        break;
      case 1:
        //formKeyStep2.currentState!.validate();
        break;
      case 2:
        //formKeyStep3.currentState!.validate();
        break;
      case 3:
        submitForm();
        break;
      default:
    }
  }
  
  //FUNÇÃO DE ANTERIOR STEP
  void previousStep() {
    step.value = step.value - 1;
  }

  //FUNÇÃO DE DEFINIÇÃO DE DADOS PARA ENVIO
  void setFormData(){

  }

  //FUNÇÃO DE PRE-ENVIO DE FORMULARIO
  void submitForm()async {
    //VERIFICAR SE TERMOS DE USO E POLITICAS FORAM SELECIONADAS
    if(termosUsoChecked && politicasChecked){
      //HABILITAR BOTÃO DE SALVAMENTO
      saveEnable = true;
    }else{
      //DESABILITAR BOTÃO DE SALVAMENTO
      saveEnable = false;
    }
    //VERIFICAR SE FORMULÁRIO PODE SER ENVIADO
    if(saveEnable){
      //AJUSTAR FORMDATA PARA ENVIO
      setFormData();
      //EXIBIR OVERLAY
      await Get.showOverlay(
        asyncFunction: () async {
          //ENVAR FORMULARIO 
          submitStatus.value = await registerUser();
        },
        loadingWidget: Material(
          color: Colors.transparent,
          child: Obx(() => FormOverlayWidget(
            status: submitStatus.value,
            form: "user",
          )),
        ),
        opacity: 0.7,
        opacityColor: AppColors.dark_700,
      );
      //FECHAR OVERLAY
      Get.back();
      //SE SUCESSO, FECHA O OVERLAY APÓS ANIMAÇÃO
      if (submitStatus.value == 200) {
        //NAVEGAR PARA ADICÃO DE PARTICIPANTES
        Get.offAllNamed('/login');
      }else{
        //EXIBIR MENSAGEM DE ERRO
        AppHelper.feedbackMessage(Get.context, "Houve um erro ao enviar as informações, tente novamente.");
      }
    }else{
      //EXIBIR MENSAGEM DE ERRO
      AppHelper.feedbackMessage(Get.context, 'Aceite os termos de uso e políticas para finalizar o cadastro');
    }
  }

  //VALIDAÇÃO DE CAMPOS
  String? validateEmpty(String? value, String label) {
    if(value?.isEmpty ?? true){
      return "$label deve ser preenchido(a)!";
    }
    return null;
  }

  //FUNÇÃO DE ENVIO DE FORMULÁRIO
  Future<int> registerUser() async {
    //BUSCAR URL BASICA
    var url = AppApi.url+AppApi.createUser;
    //ENVIAR FORMULÁRIO
    var response = await ApiService.post(formData, url);
    return response["status"];
  }
}
