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
    NavigationController navigationController = NavigationController.instance;
    List<Map<String, dynamic>> options = [
      {'label' : "Home", "icon" : Icons.home_filled,},
      {'label' : "Escalação", "icon" : AppIcones.escalacao_outline,},
      {'label' : "Peladas", "icon" : AppIcones.apito},
      {'label' : "Explore", "icon" : Icons.map_rounded,},
      {'label' : "Notificações", "icon" : Icons.notifications,},
    ];
    return Obx(
      () => NavigationBar(
        selectedIndex: navigationController.index.value,
        onDestinationSelected: (i) => navigationController.index.value = i,
        destinations: options.asMap().entries.map((item){
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
                ),
              ), 
              label: option['label']
            );
          }
          return NavigationDestination(icon: Icon(option['icon']), label: option['label']);
        }).toList(),
      ),
    );
  }
}