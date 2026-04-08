import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/controllers/showcase_controller.dart';
import 'package:get/state_manager.dart';
import 'package:showcaseview/showcaseview.dart';

class WizardWidget extends StatelessWidget {
  final String elementKey;
  final Widget child;
  const WizardWidget({
    super.key,
    required this.elementKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR ELEMENTO DO SHOWCASE;
    ShowcaseController showcaseController = ShowcaseController.instance;
    final data = showcaseController.elements[elementKey];
    final index = showcaseController.elementKeys.indexWhere((k) => k == elementKey);
    
    //VERIIFICAR SE ELEMENTO FOI ENCONTRADO
    if (data == null) return child;
    
    //VERIFICAR SE JÁ FOI COMPLETADO
    if (showcaseController.isShowcaseCompleted(elementKey)) return child;

    return Obx((){
      //VERIFICAR SE SHOWCASE ESTÁ PRONTO PARA NAVEGAR
      if(!showcaseController.isReady.value) return child;

      showcaseController.currentShowcase.value = showcaseController.elementKeys[index + 1];
      //ARREDONDADR BORDAS DE ACORDO COM O ELEMENTO
      final borderCircular = elementKey == 'menu' || elementKey == 'profile' || elementKey == 'chat';

      return Showcase.withWidget(
        key: data['key'], 
        overlayOpacity: 0.8,
        targetBorderRadius: BorderRadius.circular(borderCircular ? 50 : 10),
        targetShapeBorder: const CircleBorder(),
        targetPadding: const EdgeInsets.all(5),
        container: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            spacing: 20,
            children: [
              Text(
                data['title'],
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                data['description'],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if(data['subDescription'] != null)...[
                Text(
                  data['subDescription'],
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if(elementKey != 'home')...[
                LinearProgressIndicator(
                  value: data['progress'],
                  backgroundColor: AppColors.white.withAlpha(10),
                  color: AppColors.green_300,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 10,
                ),
              ]
            ],
          ),
        ), 
        child: child
      );
    });
  }
}