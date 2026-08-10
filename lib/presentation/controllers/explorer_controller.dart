import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/di/service_locator.dart';

//===EVENT BASE===
abstract class ExploreBase {
  //GETTER - PARTICIPANTS
  List<Map<String, dynamic>> get sportPlaces;
}

class ExplorerController extends ChangeNotifier
  with ExploreFilter implements ExploreBase {
  //DEFINIR CONTROLLER UNICO NO GETIT
  static ExplorerController get instance => sl<ExplorerController>();

  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  final List<Map<String, dynamic>> _sportPlaces = [];
  @override
  List<Map<String, dynamic>> get sportPlaces => _sportPlaces;

  void setSportPlaces(List<Map<String, dynamic>> places) {
    _sportPlaces.clear();
    _sportPlaces.addAll(places);
    notifyListeners();
  }

  void init() {}
}

//===MIXIN - FILTRO DE EVENTO===
mixin ExploreFilter on ChangeNotifier {
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

  String _order = "";
  String get order => _order;
  set order(String v) { _order = v; notifyListeners(); }

  //ESTADO - RAIO DE DISTANCIA
  int _ratio = 10;
  int get ratio => _ratio;
  set ratio(int v) { _ratio = v; notifyListeners(); }

  //ESTADO - CATEOGRIAS SELECIOANADS
  final List<String> _categories = [];
  List<String> get categories => _categories;

  //ESTADO - DIAS DA SEMANA SELECIOANADS
  final List<String> _daysWeek = [];
  List<String> get daysWeek => _daysWeek;

  //ESTADO - AVALIAÇÃO
  int _avaliation = 0;
  int get avaliation => _avaliation;
  set avaliation(int v) { _avaliation = v; notifyListeners(); }

  void setCategories(List<String> list) {
    _categories.clear();
    _categories.addAll(list);
    notifyListeners();
  }

  void setDaysWeek(List<String> list) {
    _daysWeek.clear();
    _daysWeek.addAll(list);
    notifyListeners();
  }

  //FUNÇÃO DE ENVIO DE FORMULARIO
  Future<Map<String, dynamic>> registerEvent() async {
    try {
      return {'status': 200};
    } catch (e) {
      print(e);
      return {'status': 400};
    }
  }
}
