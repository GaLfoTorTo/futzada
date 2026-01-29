import 'package:futzada/presentation/controllers/register_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/widget/bars/header_glass_widget.dart';
import 'package:futzada/presentation/widget/buttons/float_button_widget.dart';

class OnboardingStep extends StatefulWidget {
  const OnboardingStep({super.key,});

  @override
  State<OnboardingStep> createState() => _OnboardingStepState();
}

class _OnboardingStepState extends State<OnboardingStep> {
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final RegisterController registerController = Get.put(RegisterController());
  //IMAGENS
  final List<String> imgs = [
    AppImages.football,
    AppImages.volleyball,
    AppImages.basketball,
  ];
  //CORES
  final List<Color> imgColors = [
    AppColors.green_300,
    AppColors.blue_500,
    AppColors.orange_500,
  ];
  Color textColor = AppColors.blue_500;
  //ESTADO - INDEX
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    //INICIAR LOOP DE TROCA DE IMAGEM
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;

      setState(() {
        currentIndex = (currentIndex + 1) % imgs.length;
        textColor = currentIndex == 0 ? AppColors.blue_500 : AppColors.white;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: HeaderGlassWidget( 
        leftAction: () => Get.toNamed('/login'),
        brightness: currentIndex == 0 ? true : false,
      ),
      backgroundColor: imgColors[currentIndex],
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: Container(
              key: ValueKey(imgs[currentIndex]),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imgs[currentIndex]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                tileMode: TileMode.decal,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [imgColors[currentIndex].withAlpha(20), imgColors[currentIndex].withAlpha(150)]
              )
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 120, horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cadastre-se para começar a jogar',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: textColor
                  ),
                  textAlign: TextAlign.center,
                ), 
                Text(
                  'Pronto para jogar? Vamos criar seu perfil no Futzada e dar inicio a sua mais nova jornada esportiva.',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatButtonWidget(
        icon: Icons.arrow_forward_ios_rounded, 
        color: AppColors.white,
        floatKey: "avanced_register",
        backgroundColor: AppColors.blue_500,
        onPressed: () => Get.toNamed('/register/dados_basicos'),
      ),
    );
  }
}