import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class IntroductionPage extends StatelessWidget {
  final String descricao, animation;
  final PageController pageController;
  final VoidCallback action;

  const IntroductionPage({
    super.key,
    required this.descricao,
    required this.animation,
    required this.pageController,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            descricao,
            style: const TextStyle(
              fontSize: 15.0, 
              fontWeight: FontWeight.normal, 
              color: AppColors.blue_500,
            ),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Lottie.asset(
              animation,
              fit: BoxFit.fill,
              height: AppHelper.screenWidth(context),
            ),
          ),
        ],
      ),
    );
  }
}