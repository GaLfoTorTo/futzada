import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/providers/navigation_provider.dart';
import 'package:esportly/presentation/widget/showcase/wizard_widget.dart';
import 'package:esportly/presentation/controllers/navigation_controller.dart';

class NavigationBarWidget extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const NavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //RESGATAR CONTROLLERS - NAVEGAÇÃO
    NavigationController navigationController = NavigationController.instance;
    //OBSERVAR ESTADO DE PRONTIDÃO DA NAVEGAÇÃO
    final isReady = ref.watch(navReadyProvider);

    return WizardWidget(
      elementKey: 'navigation',
      child: NavigationBar(
        animationDuration: const Duration(seconds: 1),
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) {
          if (isReady) {
            onDestinationSelected(i);
          }
        },
        destinations: navigationController.options.asMap().entries.map((item){
          //VERIFICAR SE APP JÁ ESTA PRONTO PARA NAVEGAR
          if(!isReady){
            return NavigationDestination(
              icon: Icon(
                Icons.circle,
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_300.withAlpha(100) : AppColors.grey_300.withAlpha(50),
              ),
              label: "app"
            );
          }
          //RENDERIZAR BOTÕES DE TAB
          final key = item.key;
          final option = item.value;
          double size = option['icon'] == Icons.sports ? 30 : 25;
          if(key == selectedIndex){
            size = option['icon'] == Icons.sports ? 35 : 30;
            return WizardWidget(
              elementKey: option['key'],
              child: NavigationDestination(
                icon: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppColors.green_300,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Icon(
                    option['icon'],
                    color: AppColors.blue_500,
                    size: size
                  ),
                ),
                label: option['label']
              ),
            );
          }
          return WizardWidget(
            elementKey: option['key'],
            child: NavigationDestination(
              icon: Icon(
                option['icon'],
                size: size
              ),
              label: option['label']
            ),
          );
        }).toList(),
      )
    );
  }
}