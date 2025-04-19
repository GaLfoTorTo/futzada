import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback action;
  const WelcomePage({
    super.key,
    required this.action
  });

  @override
  Widget build(BuildContext context) {
    double width = AppHelper.screenWidth(context);

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Seja Bem-Vindo ao",
            style: TextStyle(
              fontSize: 24.0, 
              fontWeight: FontWeight.w500, 
              color: AppColors.blue_500
            ),
            textAlign: TextAlign.center,
          ),
          const Text(
            "FUTZADA",
            style: TextStyle(
              fontSize: 32.0, 
              fontWeight: FontWeight.bold, 
              color: AppColors.blue_500
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: width - 100,
            child: const Text(
              "Pontue, Escale, Prove que você é o MELHOR",
              style: TextStyle(
                fontSize: 20.0, 
                fontWeight: FontWeight.normal, 
                color: AppColors.blue_500
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            width: 200,
            child: Text(
              "Clique na bandeira ou arraste para o lado para prosseguir",
              style: TextStyle(
                fontSize: 15.0, 
                fontWeight: FontWeight.normal, 
                color: AppColors.blue_500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Image.asset(
                AppImages.linhas,
                width: width,
              ),
              Positioned(
                top: -5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: action, 
                    child: Lottie.asset(
                      AppAnimations.introducaoFlag,
                      fit: BoxFit.contain,
                      height: 100
                    ), 
                  ),
                ),
              ),
            ]
          ),
        ],
      ),
    );
  }
}