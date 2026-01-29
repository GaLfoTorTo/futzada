import 'package:flutter/material.dart';
import 'package:futzada/presentation/controllers/navigation_controller.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';

class DialogBackHome extends StatelessWidget {
  const DialogBackHome({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController navigationController = NavigationController.instance;
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Cancelar Cadastro',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Deseja cancelar o cadastro da pelada voltar para a página inicial ?',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonTextWidget(
                  text: "Não",
                  width: 50,
                  height: 20,
                  action: () => Get.back(),
                  backgroundColor: AppColors.red_300,
                  textColor: AppColors.white,
                ),
                ButtonTextWidget(
                  text: "Sim",
                  width: 50,
                  height: 20,
                  action: () {
                    navigationController.index.value = 0;
                    Get.offAllNamed('/home');
                  },
                  backgroundColor: AppColors.green_300,
                  textColor: AppColors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}