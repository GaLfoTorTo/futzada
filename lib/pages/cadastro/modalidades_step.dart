import 'package:flutter/material.dart';
import 'package:futzada/controllers/cadastro_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_circular_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:get/get.dart';

class ModalidadesStep extends StatelessWidget {
  const ModalidadesStep({super.key});
  
  @override
  Widget build(BuildContext context) {
    //CONTROLADOR DOS INPUTS DO FORMULÁRIO
    final CadastroController controller = Get.put(CadastroController());
    //RESGATAR DIMENSOES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE INPUTS RADIO
    final List<Map<String, dynamic>> modalidade = [
      {
        'modalidade': 'Jogador',
        'icone': AppIcones.foot_field_solid,
        'iconSize': 40.0,
        'descricao' : 'Esta modalidade e voltada aos usuários que atuaram em campo ou quadras nas partidas.',
        'checked' : controller.model.posicoes != null ? true : false,
        'route' : '/cadastro/jogador',
      },
      {
        'modalidade': 'Técnico',
        'icone': AppIcones.clipboard_solid,
        'iconSize': 70.0,
        'descricao' : 'Esta modalidade e voltada aos usuários que atuaram escalando seu times nas peladas.',
        'checked' : controller.model.equipe != null ? true : false,
        'route' : '/cadastro/tecnico',
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
                    "Modalidades",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "Agora defina suas preferências para cada modalidade disponível. Escolha que tipo de atuação você terá dentro do app. Você também pode optar ambas.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for(var item in modalidade)
                        Column(
                          children: [
                            Text(
                              item['modalidade'],
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
                    "A definição das modalidades podem ser feitas posteriores ao cadastro pórem suas ações no app serão limitadas até a conclusão.",
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
                        action: () => Get.toNamed('/cadastro/conclusao'),
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