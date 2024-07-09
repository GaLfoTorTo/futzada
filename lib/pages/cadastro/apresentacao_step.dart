import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';

class ApresentacaoStep extends StatelessWidget {
  final VoidCallback action;
  const ApresentacaoStep({
    super.key,
    required this.action
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.green_300,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Center(
                child: Text(
                  'Cadastre-se para começar a jogar',
                  style: TextStyle(
                    color: AppColors.blue_500,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                AppImages.silhueta_cadastro,
                width: 350,
                height: 300,
              ),
            ),
            const 
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Para começar a jogar suas peladas de forma muito mais divertida e organizada, vamos criar seu perfil no Futzada.',
                style: TextStyle(
                  color: AppColors.blue_500,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ButtonTextWidget(
              text: "Começar",
              textColor: AppColors.white,
              color: AppColors.blue_500,
              width: double.infinity,
              action: action,
            ),
          ],
        ),
      ),
    );
  }
}