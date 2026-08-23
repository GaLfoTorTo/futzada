import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/helpers/loading_overlay.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/data/models/player_model.dart';
import 'package:esportly/data/models/manager_model.dart';
import 'package:esportly/data/repositories/user_repository.dart';
import 'package:esportly/presentation/widget/overlays/form_overlay_widget.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class RegisterController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETIT
  static RegisterController get instance => sl<RegisterController>();
  UserRepository userRepository = UserRepository();
  //DEFINIR FORMDATA
  Map<String, dynamic> formData = {};
  //DEFINIÇÃO EXTRAS DO USUARIO
  ManagerModel manager = ManagerModel();
  PlayerModel player = PlayerModel();
  //CONTROLE DE STEP
  int _step = 0;
  int get step => _step;
  set step(int v) { _step = v; notifyListeners(); }
  // VARIÁVEL PARA CONTROLAR O STATUS
  int _submitStatus = 0;
  int get submitStatus => _submitStatus;
  set submitStatus(int v) { _submitStatus = v; notifyListeners(); }
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
  late TextEditingController privacyController;
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
  final List<String> _modalities = [];
  List<String> get modalities => _modalities;
  void setModalities(List<String> v) { _modalities.clear(); _modalities.addAll(v); notifyListeners(); }

  final List<String> _positions = [];
  List<String> get positions => _positions;
  void setPositions(List<String> v) { _positions.clear(); _positions.addAll(v); notifyListeners(); }

  Map<String, String> mainPositions = {
    "Football": "",
    "Volleyball": "",
    "Basketball": "",
  };
  //ESTADOS - MANAGER
  String emblem = "emblema_1";
  Map<String, Map<String, dynamic>>? configEmblem;
  Map<String, Map<String, dynamic>>? configUniform;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS DE TEXTO
  void init(){
    //INICIALIZAR CONTROLLERS DE TEXTO
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    userNameController = MaskedTextController(mask: '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', translator: {"@": RegExp(r'[@\w]')});
    emailController = TextEditingController();
    phoneController = MaskedTextController(mask: "(00) 00000-0000");
    bornDateController = MaskedTextController(mask: "00/00/0000");
    privacyController = TextEditingController();
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
  void dispose(){
    firstNameController.dispose();
    lastNameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bornDateController.dispose();
    privacyController.dispose();
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
    super.dispose();
  }

  //FUNÇÃO DE PROXIMO STEP
  void nextStep() {
    if(step < 3){
      step = step + 1;
    }
    switch (step) {
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
    step = step - 1;
  }

  //FUNÇÃO DE DEFINIÇÃO DE DADOS PARA ENVIO
  void setFormData(){

  }

  //FUNÇÃO DE PRE-ENVIO DE FORMULARIO
  void submitForm() async {
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
      final ctx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (ctx != null) {
        try {
          await LoadingOverlay.show(
            ctx,
            () async {
              //ENVAR FORMULARIO
              submitStatus = await registerUser();
            },
            loadingWidget: Material(
              color: Colors.transparent,
              child: ListenableBuilder(
                listenable: this,
                builder: (_, __) => FormOverlayWidget(
                  status: submitStatus,
                  form: "user",
                ),
              ),
            ),
            barrierColor: AppColors.dark_700.withAlpha(178),
          );
        } catch (e) {
          final errCtx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
          if (errCtx != null) AppHelper.feedbackMessage(errCtx, AppHelper.extractErrorMessage(e));
          return;
        }
      }
      //SE SUCESSO, NAVEGA PARA LOGIN
      if (submitStatus == 200) {
        sl<GoRouter>().go('/login');
      } else {
        //EXIBIR MENSAGEM DE ERRO
        final errCtx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
        if (errCtx != null) AppHelper.feedbackMessage(errCtx, "Houve um erro ao enviar as informações, tente novamente.");
      }
    }else{
      //EXIBIR MENSAGEM DE ERRO
      final errCtx = sl<GoRouter>().routerDelegate.navigatorKey.currentContext;
      if (errCtx != null) AppHelper.feedbackMessage(errCtx, 'Aceite os termos de uso e políticas para finalizar o cadastro');
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
    //ENVIAR FORMULÁRIO
    var resp = await userRepository.registerUser(formData);
    return resp.status;
  }
}
