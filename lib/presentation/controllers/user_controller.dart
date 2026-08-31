import 'package:flutter/foundation.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/user_service.dart';

class UserController extends ChangeNotifier {
  static UserController get instance => sl<UserController>();

  UserService _userService = UserService();

  //ESTADOS - READY E PERMISSOES
  bool _isReady = false;
  bool get isReady => _isReady;
  set isReady(bool v) { _isReady = v; notifyListeners(); }

  bool _profileCompleted = false;
  bool get profileCompleted => _profileCompleted;
  set profileCompleted(bool v) { _profileCompleted = v; notifyListeners(); }

  UserModel get user => sl<UserModel>(instanceName: 'user');

  void init() {
    isReady = true;
    getInfo();
  }

  Future<void> getInfo() async {
    final updated = await _userService.userInfoFetch();
    final current = sl<UserModel>(instanceName: 'user');
    current
      ..config       = updated.config
      ..level        = updated.level
      ..player       = updated.player
      ..manager      = updated.manager
      ..tasks        = updated.tasks
      ..participants = updated.participants
      ..achievements = updated.achievements;
    notifyListeners();
  }
}
