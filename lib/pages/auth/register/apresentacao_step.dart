import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';

class ApresentacaoStep extends StatelessWidget {
  const ApresentacaoStep({super.key,});

  @override
  Widget build(BuildContext context) {
    //FUNÇÃO DE NAVEGAÇÃO
    void proximo(){
      Get.toNamed('/register/dados_basicos');
    }

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget( 
        leftAction: () => Get.toNamed('/login'),
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.green_300,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: Text(
                      'Cadastre-se para começar a jogar',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.blue_500
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Image.asset(
                    AppImages.silhuetaCadastro,
                    width: 350,
                    height: 300,
                  ),
                ), 
                Text(
                  'Para começar a jogar suas peladas de forma muito mais divertida e organizada, vamos criar seu perfil no Futzada.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.blue_500
                  ),
                  textAlign: TextAlign.center,
                ),
                ButtonTextWidget(
                  text: "Começar",
                  textColor: AppColors.white,
                  backgroundColor: AppColors.blue_500,
                  width: double.infinity,
                  action: proximo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}