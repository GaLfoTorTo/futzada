import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/presentation/controllers/theme_controller.dart';
import 'package:futzada/presentation/widget/cards/card_info_widget.dart';
import 'package:futzada/presentation/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/presentation/controllers/register_controller.dart';

class ModalityStep extends StatefulWidget {
  const ModalityStep({super.key});

  @override
  State<ModalityStep> createState() => ModalityStepState();
}

class ModalityStepState extends State<ModalityStep> {
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final RegisterController registerController = RegisterController.instance;
  final ThemeController themeController = ThemeController.instance;
  final GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();
  //DEFINIR MODALIDADES
  List<String> modality = [
    "Futebol",
    "Volei",
    "Basquete",
  ];
  //DEFINIR CATEGORIAS
  final Map<String, List<String>> category = {
    "Futebol" : ["Futebol", "Fut7", "Futsal"],
    "Volei" : ["Volei", "Volei Praia", "Fut Volei"],
    "Basquete" : ["Basquete", "Streetball"],
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //FUNÇÃO DE REORDENAÇÃO DE MODALIDADES
  void reorderModalities(String key) {
    if (!modality.contains(key)) return;

    setState(() {
      modality.remove(key);
      final int centerIndex = (modality.length / 2).floor();
      modality.insert(centerIndex, key);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKeyStep2,
      child: SingleChildScrollView(
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Modalidades",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              "Quais são os esportes do seu coração? Escolha as modalidades que você pratica e a que você mais gosta.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const CardInfoWidget(description: "Selecione seu esporte principal clicando 2 vezes na modalidade escolhida."),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: modality.asMap().entries.map((entry){
                  //RESGATAR ICONE DA CATEGORIA
                  final key = modality[entry.key];
                  final item = ModalityHelper.getIconModality(key);
                  final isMain = registerController.mainModalityController.text == key;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: Column(
                      key: ValueKey(key), // 🔑 ESSENCIAL PARA ANIMAÇÃO
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: isMain ? 1.15 : 1.0,
                          child: SelectRoundedWidget(
                            value: key,
                            icon: item["icon"],
                            backgroundColor: item["color"],
                            iconColor: item["texColor"],
                            iconSize: 70,
                            size: 110,
                            checked: registerController.modalities.contains(key),
                            onChanged: (value) {
                              setState(() {
                                //VERIFICAR SE MODALIDADE ESTA SELECIONADA
                                if (registerController.modalities.contains(key)) {
                                  registerController.modalities.remove(key);
                                  //VERIFICAR SE MODALIDADE PRINCIPAL FOI REMOVIDA
                                  if(registerController.mainModalityController.text == key){
                                    registerController.mainModalityController.text = "";
                                  }
                                  //REORDENAR MODALIDADES
                                  modality = [
                                    "Futebol",
                                    "Volei",
                                    "Basquete",
                                  ];
                                  print(modality);
                                } else {
                                  registerController.modalities.add(key);
                                }
                              });
                            },
                            onDoubleChanged: (value) {
                              setState(() {
                                //VERIFICAR SE MODALIDADE ESTA SELECIONADA
                                if(!registerController.modalities.contains(key)){
                                  //ATUALIZAR MODALIDADE
                                  registerController.modalities.add(key);
                                  registerController.mainModalityController.text = key;
                                  //ATUALIZAR COR PRINCIPAL DA APLICAÇÃO
                                  themeController.alterPrimaryColor(key);
                                  //REORDENAR MODALIDADES
                                  reorderModalities(key);
                                }
                              });
                            },
                          ),
                        ),
                        if(isMain)...[
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 250),
                            opacity: isMain ? 1 : 0,
                            child: Column(
                              spacing: 10,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.dark_500.withAlpha(50),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  ),
                                  child: const Icon(
                                    Icons.workspace_premium,
                                    color: AppColors.yellow_500,
                                    size: 36,
                                  ),
                                ),
                                Text(
                                  "Modalidade Principal",
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                    color: AppColors.blue_500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                }).toList()
              ),
            ),
            if(registerController.modalities.isNotEmpty)...[
              const Divider(),
              Text(
                "Categorias",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                "As modalidades selecionadas disponibilizarão as seguintes categorias disponíveis para você participar de peladas e ventos.",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              ...modality.map((m){
                return Row(
                  spacing: 40,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if(registerController.modalities.contains(m))...[
                      ...category[m]!.map((key){
                        //RESGATAR ICONE DA CATEGORIA
                        final item = ModalityHelper.getIconCategory(key);
                        return SelectRoundedWidget(
                          value: key,
                          icon: item["icon"],
                          backgroundColor: item["color"],
                          iconColor: item["texColor"],
                          iconSize: 40,
                          size: 70,
                          checked: true,
                          onChanged: (){},
                        );
                      }),
                    ]
                  ]
                );
              })
            ]
          ],
        ),
      ),
    );
  }
}