import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:futzada/data/services/timer_service.dart';
import 'package:futzada/presentation/controllers/auth_controller.dart';
import 'package:futzada/presentation/controllers/explorer_controller.dart';
import 'package:futzada/presentation/controllers/user_controller.dart';
import 'package:futzada/presentation/controllers/home_controller.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/controllers/rank_controller.dart';
import 'package:futzada/presentation/controllers/chat_controller.dart';
import 'package:futzada/presentation/controllers/notification_controller.dart';
import 'package:futzada/presentation/controllers/statistics_controller.dart';

class AppController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static AppController get instance => Get.find();
  //RESGATAR CONTROLLER DE AUTENTICAÇÃO
  final AuthController authController = Get.find();
  //INICIALIZAÇÃO - CONTROLLERS (USER, HOME)
  late UserController userController;
  late HomeController homeController;
  //ESTADOs - CONTROLE DE INICIALIZAÇÃO
  RxBool isReady = false.obs;
  RxBool homeReady = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasError = false.obs;

  late Worker userWorker;
  late Worker homeWorker;

  @override
  void onReady() {
    super.onReady();
    isLoading.value = true;
    //INICIALIZAR CONTROLLERS
    userController = Get.put(UserController(), permanent: true);
    userWorker = ever<bool>(userController.isReady, (isReady) async {
      if(!isReady)return;
      homeController = Get.put(HomeController(), permanent: true);
      Get.put(GameController(), permanent: true);
      //ESPERAR HOME CONTROLLER INICIALIZAR
      homeWorker = ever<bool>(homeController.isReady, (homeReady) async {
        if (!homeReady) return;
        navigateUser();
        await initControllers();
        //ENCERRAR WORKERS
        userWorker.dispose();
        homeWorker.dispose();
      });
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  //FUNÇÃO DE INICIALIZAÇÃO DE DADOS DE USUARIO
  Future<void> initControllers() async {
    try {
      //INICIALIZAÇÃO - CONTROLLERS (EVENTO, ESCALAÇÃO, STATISTICA, GAME, RANK, EXPLORER, CHAT, NOTIFICATION)
      Get.lazyPut(() => EventController(), fenix: true);
      Get.lazyPut(() => EscalationController(), fenix: true);
      Get.lazyPut(() => StatisticsController(), fenix: true);
      Get.lazyPut(() => RankController(), fenix: true);
      Get.lazyPut(() => ExplorerController(), fenix: true);
      Get.lazyPut(() => ChatController(), fenix: true);
      Get.lazyPut(() => NotificationController(), fenix: true);
      //ATUALIZAR ESTADOS DE INICIALIZAÇÃO
      isLoading.value = false;
      isReady.value = true;
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

  //FUNÇÃO DE NAVEGAÇÃO APOS LOGIN 
  void navigateUser(){
    //VERIFICAR SE É O PRIMEIRO LOGIN
    if(!GetStorage().hasData('firstLogin')){
      //NAVEGAR PARA APRESENTAÇÃO PAGE
      Get.offAllNamed('/onboarding');
      return;
    }else{
      //NAVEGAR PARA APRESENTAÇÃO PAGE
      Get.offAllNamed('/home');
      return;
    } 
  }
}