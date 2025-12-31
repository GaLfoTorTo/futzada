import 'package:get/get.dart';
import 'package:futzada/controllers/user_controller.dart';
import 'package:futzada/controllers/home_controller.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/controllers/rank_controller.dart';
import 'package:futzada/controllers/chat_controller.dart';
import 'package:futzada/controllers/notification_controller.dart';
import 'package:futzada/services/timer_service.dart';

class AppController extends GetxController {
  //ESTADOs - CONTROLE DE INICIALIZAÇÃO
  RxBool isReady = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  Future<void> initApp() async {
    try {
      //ESTADOS - INICIALIZAÇÃO
      isReady.value = false;
      isLoading.value = true;
      hasError.value = false;
      //INICIALIZAÇÃO DE CONTROLLER DE USUARIO
      final userController = Get.put(UserController());
      //RESGATAR POSIÇÃO ATUAL DO USUARIO
      await userController.getCurrentLocation();
      //INICIALIZAÇÃO DE CONTROLLER DE HOME PAGE
      final homeController = Get.put(HomeController());
      await homeController.fetchHome();
      //INICIALIZAÇÃO DE DEMAIS CONTROLLERS
      Get.put(EventController());
      Get.put(EscalationController());
      Get.put(GameController());
      Get.put(RankController());
      /* Get.put(ExplorerController()); */
      Get.put(ChatController());
      Get.put(NotificationController());
      //INICIALIZAR SERVIÇOS
      initServices();
      //ATUALUZAR ESTADOS DE INICIALIZAÇÃO
      isReady.value = true;
      isLoading.value = false;
    } catch (e) {
      //ATUALUZAR ESTADOS DE INICIALIZAÇÃO
      hasError.value = true;
      isLoading.value = false;
    }
  }

  //FUNÇÃO DE INICIALIZAÇÃO DE SERVIÇOS
  void initServices(){
    //INICIALIZAR SERVIÇO DE CRONOMETRO
    Get.put(TimerService());
  }
}
