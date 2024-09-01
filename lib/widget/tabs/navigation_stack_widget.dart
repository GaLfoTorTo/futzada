import 'package:flutter/material.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:get/get.dart';

class NavigationStackWidget extends StatelessWidget {
  const NavigationStackWidget({super.key});

  //FUNÇÃO PARA CONSTRUÇÃO DE NAVIGATOR DINAMICO
  Navigator buildNavigator(GetxController controller) {
    return Navigator(
      key: (controller as dynamic).navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => (controller as dynamic).screens[(controller as dynamic).index.value],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //BUSCAR CONTROLLADOR DE BARRA DE NAVEGAÇÃO
    final controller = Get.find<NavigationController>();
    //LISTA DE NAVIGATORS PARA CADA ABA
    List<Widget> navigators = [
      buildNavigator(controller.homeController),
      buildNavigator(controller.escalacaoController),
      buildNavigator(controller.peladaController),
      buildNavigator(controller.exploreController),
      buildNavigator(controller.notificacaoController),
    ];

    return Obx(() => IndexedStack(
      index: controller.index.value,
      children: navigators,
    ));
  }
}