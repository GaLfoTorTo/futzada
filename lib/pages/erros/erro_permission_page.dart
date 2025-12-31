import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/controllers/user_controller.dart';

class ErroPermissionPage extends StatelessWidget {
  const ErroPermissionPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE USUARIO
    UserController userController = UserController.instance;

    return  Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        color: AppColors.white,
        child: Column(
          spacing: 50,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Não foi possível acessar a sua localização atual.',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const Icon(
              Icons.location_off,
              size: 200,
              color: AppColors.blue_500,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Parece que você não concedeu acesso a sua localização atual para o app. Certifique-se de permitir acesso a sua localização para podermos buscar as peladas de sua redondeza.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                ButtonTextWidget(
                  text: "Permitir Localização",
                  width: dimensions.width,
                  icon: Icons.location_on,
                  iconSize: 30,
                  action: () => userController.getCurrentLocation(),
                ),
                const Padding(padding: EdgeInsets.all(10)),
              ],
            )
          ],
        ),
      ),
    );
  }
}