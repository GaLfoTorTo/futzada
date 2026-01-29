import 'package:flutter/material.dart';
import 'package:get/get.dart';

//===EVENT BASE===
abstract class ExploreBase {
  //GETTER - PARTICIPANTS
  RxList<Map<String, dynamic>> get sportPlaces;
}

class ExplorerController extends GetxController
  with ExploreFilter implements ExploreBase {
  //DEFINIR CONTROLLER UNICO NO GETX
  static ExplorerController get instance => Get.find();
  //DEFINIR DE PARTICIPANTES
  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  @override
  RxList<Map<String, dynamic>> sportPlaces = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
}

//===MIXIN - FILTRO DE EVENTO===
mixin ExploreFilter on GetxController{
  //CONTROLLADOR DE PESQUISA MANUAL
  TextEditingController pesquisaController = TextEditingController();
  TextEditingController orderController = TextEditingController();
  //CONTROLLERS DE CAMPOS DE FILTROS
  late TextEditingController ratioController;
  late TextEditingController categoriesController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  late TextEditingController minController;
  late TextEditingController maxController;
  late TextEditingController avaliationController;
  
  //FUNÇÃO PARA INICIALIZAR CONTROLLERS
  void initTextControllers() {
    //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
    ratioController = TextEditingController();
    categoriesController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    minController = TextEditingController();
    maxController = TextEditingController();
    avaliationController = TextEditingController();
  }

  //FUNÇÃO PARA FINALIZAR CONTROLLERS
  void disposeTextControllers() {
    ratioController.dispose();
    categoriesController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    minController.dispose();
    maxController.dispose();
    avaliationController.dispose();
  }

  RxString order = "".obs;
  //ESTADO - RAIO DE DISTANCIA
  RxInt ratio = 10.obs;
  //ESTADO - CATEOGRIAS SELECIOANADS
  RxList<String> categories = <String>[].obs;
  //ESTADO - DIAS DA SEMANA SELECIOANADS
  RxList<String> daysWeek = <String>[].obs;
  //ESTADO - AVALIAÇÃO
  RxInt avaliation = 0.obs;

  //FUNÇÃO DE ENVIO DE FORMULARIO
  Future<Map<String, dynamic>> registerEvent() async {
    //RESGATAR INSTANCIA DO CONTROLLER
    //ExploreController eventController = ExploreController.instance;
    try {  
      //RESGATAR EVENTO SELECIONADO
      /* //BUSCAR URL BASICA
      String url = AppApi.url + AppApi.createEvent;
      //RESGATAR USUARIO LOGADO
      UserModel user = Get.find(tag: 'user');
      //RESGATAR OPTIONS
      var options = await ApiService.setOption(user);
      //ENVIAR FORMULÁRIO
      var response = await ApiService.sendForm(event, options, url);
      return response; */
      return {'status': 200};
    } catch (e) {
      print(e);
      //RETORNAR STATUS DE ERRO
      return {'status': 400};
    }
  }
}
