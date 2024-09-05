import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/navigation_controller.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //BUSCAR CONTROLLADOR DE NAVEGAÇÃO
    final controller = NavigationController.instace;
    return Obx(
      () => NavigationBar(
        selectedIndex: controller.index.value,
        onDestinationSelected: (i) => controller.index.value = i,
        destinations:  [
          const NavigationDestination(
            icon: Icon(AppIcones.home_outline),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(AppIcones.escalacao_outline),
            label: 'Escalação'
          ),
          NavigationDestination(
            icon: Container(
              decoration: BoxDecoration(
                color: AppColors.green_300,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.green_300, width: 15),
              ),
              child: const Icon(AppIcones.apito, color: AppColors.blue_500),
            ),
            label: 'Peladas'
          ),
          const NavigationDestination(
            icon: Icon(AppIcones.map_marked_outline),
            label: 'Explore'
          ),
          const NavigationDestination(
            icon: Icon(AppIcones.bell_outline),
            label: 'Notificações'
          ),
        ]
      ),
    );
  }
}