import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/pages/register/conclusion_step.dart';
import 'package:futzada/presentation/pages/register/modality_step.dart';
import 'package:futzada/presentation/pages/register/modes_step.dart';
import 'package:futzada/presentation/widget/buttons/button_outline_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/presentation/pages/register/user_step.dart';
import 'package:futzada/presentation/controllers/register_controller.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';

class RegisterStep extends StatefulWidget {
  
  const RegisterStep({super.key});

  @override
  State<RegisterStep> createState() => _RegisterBasicStepState();
}

class _RegisterBasicStepState extends State<RegisterStep> {
  //CONTROLADOR DOS INPUTS DO FORMULÁRIO
  final RegisterController registerController = RegisterController.instance;
  //LISTA DE ICONES DAS ETAPAS
  List<IconData> iconsStep = [AppIcones.user_solid, AppIcones.modality_solid, AppIcones.user_cog_solid, Icons.check];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
        title: "Cadastro", 
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Theme.of(context).primaryColor,
          ),
          child: Stepper(
            elevation: 3,
            type: StepperType.horizontal,
            stepIconWidth: 50,
            stepIconHeight: 50,
            stepIconMargin: const EdgeInsets.symmetric(horizontal: 5),
            stepIconBuilder: (stepIndex, stepState) {
              return Icon(
                iconsStep[stepIndex],
                color: stepIndex == registerController.step.value ? AppColors.white : AppColors.blue_500,
                size: 25,
              );
            },
            controlsBuilder: (context, details) {
              return Row(
                mainAxisAlignment: registerController.step.value != 0 
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
                children: [
                  if(registerController.step.value != 0)...[
                    ButtonOutlineWidget(
                      width: 100,
                      height: 35,
                      icon: Icons.arrow_back_rounded,
                      text: "Voltar",
                      action: () => setState(() => registerController.previousStep())
                    ),
                  ],
                  ButtonTextWidget(
                    width: 100,
                    height: 35,
                    iconAfter: registerController.step.value < 3,
                    icon: registerController.step.value == 3 ? Icons.save : Icons.arrow_forward_rounded,
                    text: registerController.step.value == 3 ? "Salvar" : "Continuar",
                    action: () => setState(() => registerController.nextStep())
                  )
                ],
              );
            },
            connectorColor: WidgetStateColor.resolveWith((state) => state.contains(WidgetState.selected) ? AppColors.blue_500 : AppColors.white),
            currentStep: registerController.step.value,
            steps: [
              Step(
                title: const SizedBox.shrink(),
                isActive: registerController.step.value == 0,
                content: const UserStep()
              ),
              Step(
                title: const SizedBox.shrink(),
                isActive: registerController.step.value == 1,
                content: const ModalityStep()
              ),
              Step(
                title: const SizedBox.shrink(),
                isActive: registerController.step.value == 2,
                content: const ModesStep()
              ),
              Step(
                title: const SizedBox.shrink(),
                isActive: registerController.step.value == 3,
                content: const ConclusionStep()
              )
            ]
          ),
        ),
      )
    );
  }
}