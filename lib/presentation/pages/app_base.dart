import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/navigation_controller.dart';
import 'package:futzada/presentation/widget/drawers/drawer_widget.dart';
import 'package:futzada/presentation/widget/bars/navigation_bar_widget.dart';

class AppBase extends StatelessWidget {
  const AppBase({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigationController navigationController = NavigationController.instance;

    return Scaffold(
      key: navigationController.scaffoldKey,
      drawer: const DrawerWidget(),
      body: Obx(() => navigationController.screens[navigationController.index.value]),
      bottomNavigationBar: const NavigationBarWidget(),
    );
  }
}
