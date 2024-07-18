import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    //INICIALIZAR CONTROLLER DE AUTENTICAÇÃO
    final authController = AuthController();
    //VERIFICAR SE EXISTE USUÁRIO SALVO LOCALMENTE
    authController.hasUsuario(context);

    return Scaffold(
      backgroundColor: AppColors.green_300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:40),
              child: SvgPicture.asset(
                AppIcones.logo,
                width: 270,
                height: 270,
              ),
            ),
            const Text(
              'Futzada',
              style: TextStyle(
                color: AppColors.blue_500,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        )
      ),
    );
  }
}