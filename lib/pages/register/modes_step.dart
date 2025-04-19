import 'package:flutter/material.dart';
import 'package:futzada/controllers/register_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_circular_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:get/get.dart';

class ModesStep extends StatelessWidget {
  const ModesStep({super.key});
  
  @override
  Widget build(BuildContext context) {
    //CONTROLADOR DOS INPUTS DO FORMULÁRIO
    final RegisterController controller = Get.put(RegisterController());
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> modos = [
      {
        'modos': 'Jogador',
        'icone': AppIcones.foot_field_solid,
        'iconSize': 40.0,
        'descricao' : 'Este modo e voltado aos usuários que atuaram em campo ou quadras nas partidas.',
        'checked' : controller.model.player?.positions != null ? true : false,
        'route' : '/register/jogador',
      },
      {
        'modos': 'Técnico',
        'icone': AppIcones.clipboard_solid,
        'iconSize': 70.0,
        'descricao' : 'Este modo e voltado aos usuários que atuaram escalando seu times nas peladas.',
        'checked' : controller.model.manager?.team != null ? true : false,
        'route' : '/register/tecnico',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro", 
        leftAction: () => Get.back()
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: dimensions.width,
            height: dimensions.height - 100,
            padding: const EdgeInsets.all(15),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const IndicatorFormWidget(
                  length: 3,
                  etapa: 1
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Modos",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Agora escolha o tipo de atuação você deseja ter no app. Defina suas preferências para cada modo de jogo disponível podendo optar por ambas as opções.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for(var item in modos)
                        Column(
                          children: [
                            Text(
                              item['modos'],
                              style: Theme.of(context).textTheme.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ButtonCircularWidget(
                                color: AppColors.green_300,
                                icon: item['icone'],
                                iconColor: AppColors.white,
                                iconSize: item['iconSize'],
                                checked: item['checked'],
                                size: 120,
                                action: () => Get.toNamed(item['route']),
                              ),
                            ),
                            Container(
                              width: 150,
                              child: Text(
                                item['descricao'],
                                style: Theme.of(context).textTheme.bodySmall,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "A definição dos modos de jogo podem ser feitas posteriores ao cadastro, pórem suas ações no app serão limitadas até lá.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ButtonOutlineWidget(
                        text: "Voltar",
                        width: 100,
                        action: () => Get.back(),
                      ),
                      ButtonTextWidget(
                        text: "Próximo",
                        width: 100,
                        action: () => Get.toNamed('/register/Conclusion'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}