import 'package:flutter/material.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/controllers/pelada_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:get/get.dart';

class DadosParticipantesStep extends StatefulWidget {
  const DadosParticipantesStep({super.key});

  @override
  State<DadosParticipantesStep> createState() => _DadosParticipantesStepState();
}

class _DadosParticipantesStepState extends State<DadosParticipantesStep> {
  //DEFINIR FORMkEY
  final formKey = GlobalKey<FormState>();
  //CONTROLLER DE REGISTRO DA PELADA
  final controller = Get.find<PeladaController>();

  @override
  Widget build(BuildContext context) {
    //CONTROLLER DE BARRA NAVEGAÇÃO
    final navigationController = Get.find<NavigationController>();
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Cadastro Pelada", 
        leftAction: () => Get.back(),
        rightAction: () => navigationController.backHome(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 2
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Adicionar Participantes",
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),]
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Estamos quase lá! Agora so precisamos adicionar os participantes da pelada para começarmos a jogar.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
              )
            )
          )
        )
      )
    );            
  }
}