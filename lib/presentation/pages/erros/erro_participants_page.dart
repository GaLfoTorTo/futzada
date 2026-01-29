import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';

class ErroParticipantsPage extends StatelessWidget {
  const ErroParticipantsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR COR APARTIR DO TEMA
    final backgroundColor = Get.isDarkMode ? AppColors.dark_500 : AppColors.white;

    return  Container(
      width: dimensions.width,
      height: dimensions.height - 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor.withAlpha(50),
            backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Sua pelada não tem nenhum participante registrado',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(
            Icons.person_off_rounded,
            size: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Parece que sua peladas não tem nenhum participante registrado até o momento. Inicie a convocação dos participantes para fazerem parte da sua pelada.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              ButtonTextWidget(
                text: "Adicionar Participantes",
                width: dimensions.width,
                icon: Icons.person_add,
                iconSize: 30,
                action: () => {},
              ),
            ],
          )
        ],
      ),
    );
  }
}