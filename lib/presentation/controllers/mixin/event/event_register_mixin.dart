//===MIXIN - REGISTRO EVENTO===
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:esportly/core/enum/enums.dart';
import 'package:esportly/data/models/address_model.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/game_config_model.dart';
import 'package:esportly/presentation/controllers/event_controller.dart';

mixin EventRegisterMixin on ChangeNotifier {
  //CONTROLLERS DE INFORMAÇÕES BASICAS DO EVENTO
  late TextEditingController titleController;
  late TextEditingController bioController;
  late TextEditingController photoController;
  late TextEditingController allowCollaboratorsController;
  late TextEditingController privacyController;
  //CONTROLLERS DE ENDEREÇO E DATA DO EVENTO
  AddressModel addressEvent = AddressModel();
  late TextEditingController dateController;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;
  //CONTROLLERS DE CONFIGURAÇÕES DE PARTIDA DO EVENTO
  late TextEditingController categoryController;
  late TextEditingController durationController;
  late TextEditingController hasTwoHalvesController;
  late TextEditingController hasExtraTimeController;
  late TextEditingController hasPenaltyController;
  late TextEditingController hasGoalLimitController;
  late TextEditingController hasRefereerController;
  late TextEditingController playersPerTeamController;
  late TextEditingController extraTimeController;
  late TextEditingController goalLimitController;
  //CONTROLLERS DE PARTICIPANTES DO EVENTO
  late TextEditingController participantsController;

  //FUNÇÃO PARA INICIALIZAR CONTROLLERS
  void initTextControllers() {
    titleController = TextEditingController();
    bioController = TextEditingController();
    photoController = TextEditingController();
    allowCollaboratorsController = TextEditingController(text: 'false');
    privacyController = TextEditingController();
    dateController = TextEditingController();
    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    categoryController = TextEditingController();
    durationController = TextEditingController();
    hasTwoHalvesController = TextEditingController(text: 'false');
    hasExtraTimeController = TextEditingController(text: 'false');
    hasPenaltyController = TextEditingController(text: 'false');
    hasGoalLimitController = TextEditingController(text: 'false');
    hasRefereerController = TextEditingController(text: 'false');
    playersPerTeamController = TextEditingController();
    extraTimeController = TextEditingController();
    goalLimitController = TextEditingController();
    participantsController = TextEditingController();
  }

  //FUNÇÃO PARA FINALIZAR CONTROLLERS
  void disposeTextControllers() {
    titleController.dispose();
    bioController.dispose();
    photoController.dispose();
    allowCollaboratorsController.dispose();
    privacyController.dispose();
    dateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    categoryController.dispose();
    durationController.dispose();
    hasTwoHalvesController.dispose();
    hasExtraTimeController.dispose();
    hasPenaltyController.dispose();
    hasGoalLimitController.dispose();
    hasRefereerController.dispose();
    playersPerTeamController.dispose();
    extraTimeController.dispose();
    goalLimitController.dispose();
    participantsController.dispose();
  }

  //FUNÇÃO DE MONTAGEM DE OBJETO DE CONFIGURAÇÕES DA PARTIDA
  GameConfigModel setGameConfigEvent() {
    final eventController = this as EventController;
    return GameConfigModel(
      category: category,
      eventId: eventController.event.id!,
      duration: int.parse(durationController.text),
      playersPerTeam: int.parse(playersPerTeamController.text),
      config: {
        "hasTwoHalves" : bool.parse(hasTwoHalvesController.text),
        "hasExtraTime" : bool.parse(hasExtraTimeController.text),
        "hasPenalty" : bool.parse(hasPenaltyController.text),
        "hasGoalLimit" : bool.parse(hasGoalLimitController.text),
        "hasRefereer" : bool.parse(hasRefereerController.text),
        "extraTime" : bool.parse(hasExtraTimeController.text) ? int.parse(extraTimeController.text) : null,
        "goalLimit" : bool.parse(hasGoalLimitController.text) ? int.parse(goalLimitController.text) : null,
      },
    );
  }

  //FUNÇÃO DE MONTAGEM DE OBJETO DE ENVIO PARA O FORMULÁRIO
  EventModel setEventRegister() {
    return EventModel(
      title: titleController.text,
      bio: bioController.text,
      date: daysWeek,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
      collaborators: bool.parse(allowCollaboratorsController.text),
      photo: photoController.text,
      privacy: Privacy.values.firstWhere((item) => item.name == privacyController.text),
      address: addressEvent,
      gameConfig: setGameConfigEvent(),
    );
  }

  //ESTADOS DE PERMISSÃO
  Map<String, dynamic> permissions = {
    'Adicionar': false,
    'Editar': false,
    'Remover': false,
  };

  //LISTA DE DIAS DA SEMANA
  Map<String, bool> daysOfWeek = {
    'Dom': false,
    'Seg': false,
    'Ter': false,
    'Qua': false,
    'Qui': false,
    'Sex': false,
    'Sab': false,
  };

  //ESTADO - DIAS DA SEMANA SELECIOANADS
  final List<String> _daysWeek = [];
  List<String> get daysWeek => _daysWeek;
  void setDaysWeek(List<String> days) {
    _daysWeek.clear();
    _daysWeek.addAll(days);
    notifyListeners();
  }

  //MAP DE CONVITE PADRÃO
  Map<String, bool> invite = {
    'Jogador': false,
    'Técnico': false,
    'Arbitro': false,
    'Colaborador': false,
  };

  //LISTA DE AMIGOS
  final List<Map<String, dynamic>> _friends = List.generate(30, (i) {
    return {
      "invite": {
        'Jogador': false,
        'Técnico': false,
        'Arbitro': false,
        'Colaborador': false,
      },
      "checked": false,
      "user": {},
    };
  });
  List<Map<String, dynamic>> get friends => _friends;

  //TOGGLE DE CONVITE DE AMIGO
  void toggleFriend(Map<String, dynamic> item) {
    item['checked'] = !(item['checked'] as bool);
    notifyListeners();
  }

  //ESTADO - CATEGORIA
  String _category = "";
  String get category => _category;
  set category(String v) { _category = v; notifyListeners(); }

  //ESTADO - LABEL DE DATA
  String _labelDate = 'Dias da Semana';
  String get labelDate => _labelDate;
  set labelDate(String v) { _labelDate = v; notifyListeners(); }

  //ESTADO - MENSAGEM DE ENDEREÇO
  String _addressText = 'Escolher endereço';
  String get addressText => _addressText;
  set addressText(String v) { _addressText = v; notifyListeners(); }

  //FUNÇÃO DE ENVIO DE FORMULARIO
  Future<Map<String, dynamic>> registerEvent() async {
    try {
      EventModel event = setEventRegister();
      print(event);
      return {'status': 200};
    } catch (e) {
      print(e);
      return {'status': 400};
    }
  }
}
