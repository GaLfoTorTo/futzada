import 'package:flutter/foundation.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/task_model.dart';
import 'package:esportly/data/services/task_service.dart';
import 'package:esportly/data/services/address_service.dart';
import 'package:esportly/data/services/firebase/firebase_service.dart';
import 'package:esportly/data/repositories/event_repository.dart';

class UserController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETX
  static UserController get instance => sl<UserController>();
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  EventRepository eventRepository = EventRepository();
  AddressService addressService = AddressService();
  TaskService taskService = TaskService();
  FirebaseService firebaseService = FirebaseService();

  //ESTADOS - READY E PERMISSOES
  bool _isReady = false;
  bool get isReady => _isReady;
  set isReady(bool v) { _isReady = v; notifyListeners(); }

  bool _profileCompleted = false;
  bool get profileCompleted => _profileCompleted;
  set profileCompleted(bool v) { _profileCompleted = v; notifyListeners(); }

  //ESTADOS - POSIÇÃO, ZOOM E CARREGAMENTO DO MAPA
  late List<TaskModel?> tasks;

  void init() {
    tasks = [];
    isReady = true;
  }
}
