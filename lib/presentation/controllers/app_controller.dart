import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/storage/app_storage.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/core/di/modules/session.dart';
import 'package:esportly/core/providers/app_session_provider.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/controllers/user_controller.dart';
import 'package:esportly/presentation/controllers/home_controller.dart';


class AppController extends ChangeNotifier {
  //INICIALIZAÇÃO - CONTROLLERS (USER, HOME)
  UserController userController = sl<UserController>();
  HomeController homeController = sl<HomeController>();
  
  //ESTADOs - CONTROLE DE INICIALIZAÇÃO
  bool _isReady = false;
  bool get isReady => _isReady;
  set isReady(bool v) { _isReady = v; notifyListeners(); }

  bool _homeReady = false;
  bool get homeReady => _homeReady;
  set homeReady(bool v) { _homeReady = v; notifyListeners(); }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool v) { _isLoading = v; notifyListeners(); }

  bool _hasError = false;
  bool get hasError => _hasError;
  set hasError(bool v) { _hasError = v; notifyListeners(); }

  //FUNÇÃO DE INICIALIZAÇÃO DE APP GERAL
  Future<void> init(UserModel user) async {
    isLoading = true;
    try {
      await registerSession(user);
      await registerEvents(user);
      await registerLocation();
      userController.init();
      homeController.init();
      final session = sl<ProviderContainer>().read(appSessionProvider.notifier);
      if (!AppStorage.hasData('firstLogin')) {
        session.setFirstLogin();
      } else {
        session.setAuthenticated();
      }
    } finally {
      isLoading = false;
    }
  }

}
