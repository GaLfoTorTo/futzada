import 'package:get/get.dart';
import 'package:futzada/presentation/controllers/auth_controller.dart';
import 'package:futzada/presentation/controllers/navigation_controller.dart';
import 'package:futzada/presentation/controllers/theme_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    //INICIALIZAÇÃO DE CONTROLLERS
    Get.put(ThemeController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
  }
}
