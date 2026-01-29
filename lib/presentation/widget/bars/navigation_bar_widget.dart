import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/controllers/navigation_controller.dart';

class NavigationBarWidget extends StatelessWidget {
  const NavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLERS - NAVEGAÇÃO
    NavigationController navigationController = NavigationController.instance;

    return Obx(() => NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: navigationController.index.value,
        onDestinationSelected: (i) {
          //VERIFICAR SE APP JA ESTA PRONTO PARA NAVEGAR
          if(navigationController.isReady.value){
            navigationController.index.value = i;
          }
        },
        destinations: navigationController.options.asMap().entries.map((item){
          //VERIFICAR SE APP JÁ ESTA PRONTO PARA NAVEGAR
          if(!navigationController.isReady.value){
            return  NavigationDestination(
              icon: Icon(
                Icons.circle,
                color: Get.isDarkMode ? AppColors.dark_300.withAlpha(100) : AppColors.grey_300.withAlpha(50),
              ), 
              label: "app"
            );
          }
          //RENDERIZAR BOTÕES DE TAB
          final key = item.key;
          final option = item.value;
          if(key == navigationController.index.value){
            return NavigationDestination(
              icon: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.green_300,
                  borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(
                  option['icon'],
                  color: AppColors.blue_500,
                  size: 30
                ),
              ), 
              label: option['label']
            );
          }
          return NavigationDestination(
            icon: Icon(
              option['icon'],
              size: 25
            ), 
            label: option['label']
          );
        }).toList(),
      ),
    );
  }
}