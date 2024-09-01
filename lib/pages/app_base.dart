import 'package:flutter/material.dart';
import 'package:futzada/widget/tabs/navigation_stack_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/widget/drawers/drawer_widget.dart';
import 'package:futzada/widget/tabs/navigation_bar_widget.dart';

class AppBase extends StatelessWidget {
  const AppBase({super.key});
  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE NAVEGAÇÃO
    final controller = Get.put(NavigationController());
    
    return Scaffold(
      key: controller.scaffoldKey,
      onDrawerChanged: (isOpened) => controller.scaffoldKey.currentState?.openEndDrawer(),
      drawer: const DrawerWidget(),
      body: const NavigationStackWidget(),
      bottomNavigationBar: const NavigationBarWidget(),
    );
  }
}
