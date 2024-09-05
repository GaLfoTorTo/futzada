import 'package:flutter/material.dart';
import 'package:futzada/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/widget/drawers/drawer_widget.dart';
import 'package:futzada/widget/tabs/navigation_bar_widget.dart';

class AppBase extends StatelessWidget {
  const AppBase({super.key});
  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE NAVEGAÇÃO
    final controller = NavigationController.instace;
    //INICIALIZAR HOME CONTROLLER
    Get.put(HomeController());
    
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: const DrawerWidget(),
      body: Obx(() => controller.screens[controller.index.value]),
      bottomNavigationBar: const NavigationBarWidget(),
    );
  }
}
