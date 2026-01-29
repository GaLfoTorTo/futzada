import 'package:futzada/presentation/widget/cards/card_info_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/controllers/register_controller.dart';
import 'package:futzada/presentation/widget/buttons/button_circular_widget.dart';

class ModesStep extends StatelessWidget {
  const ModesStep({super.key});
  
  @override
  Widget build(BuildContext context) {
    //CONTROLADOR DOS INPUTS DO FORMULÁRIO
    final RegisterController registerController = RegisterController.instance;
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> modes = [
      {
        'mode': 'Jogador',
        'icone': AppIcones.foot_futebol_solid,
        'iconSize': 40.0,
        'descricao' : 'Modo voltado aos usuários que querem atuar como jogadores nas partidas da pelada.',
        'route' : '/register/player',
      },
      {
        'mode': 'Técnico',
        'icone': AppIcones.clipboard_solid,
        'iconSize': 70.0,
        'descricao' : 'Modo voltado aos usuários que querem atuar como tecnicos, escalando sua equipe na pelada.',
        'route' : '/register/manager',
      },
    ];

    return SingleChildScrollView(
      child: Column(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Atuação",
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            "Agora escolha os tipo de atuação que você deseja ter no app e defina suas preferências para cada uma.",
            style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
          ),
          const CardInfoWidget(description: "As configurações de atuação são uma extensão das definições de usuário, elas serão aplicadas para todas as peladas que vc participar. Essas definições podem ser feitas após o cadastro nas configurações do usuário."),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: modes.map((item){
              //CHECKED DE ATUAÇÃO CONFIGURADA
              bool checked = item["mode"] == "Jogador" ? registerController.playerChecked : registerController.managerChecked;
    
              return Column(
                children: [
                  Text(
                    item['mode'],
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ButtonCircularWidget(
                      icon: item['icone'],
                      iconSize: item['iconSize'],
                      iconColor: checked ? AppColors.blue_500 : AppColors.white,
                      color: checked ? Theme.of(context).primaryColor : AppColors.grey_300,
                      checked: checked,
                      size: 120,
                      action: () => Get.toNamed(item['route']),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      item['descricao'],
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 20,)
        ],
      ),
    );
  }
}