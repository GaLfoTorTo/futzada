import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/rule_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/inputs/input_text_editor_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';

class BottomSheetRule extends StatefulWidget {
  final RuleModel? rule;
  const BottomSheetRule({
    super.key,
    this.rule,
  });

  @override
  State<BottomSheetRule> createState() => _BottomSheetRuleState();
}

class _BottomSheetRuleState extends State<BottomSheetRule> {
  //RESGATAR CONTROLLER DO EVENTO
  EventController eventController = EventController.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //INICIALIZAR CONTROLADORES DE TEXTO
    eventController.initRuleTextControllers({
      'title' : widget.rule?.title,
      'description' : widget.rule?.description,
    });
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Container(
      height: dimensions.height,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            Text(
              widget.rule != null ? "Editar Regra" : "Nova Regra",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const Divider(color: AppColors.gray_300),
            InputTextWidget(
              name: 'title',
              label: 'Titulo',
              textController: eventController.ruleTitleController,
              backgroundColor: Get.isDarkMode ? AppColors.dark_500.withAlpha(60) : AppColors.gray_300.withAlpha(60),
              type: TextInputType.text,
            ),
            InputTextEditorWidget(
              name: 'description',
              label: 'Descrição',
              bgColor: AppColors.gray_300.withAlpha(60),
              textController: eventController.ruleDescriptionController,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ButtonTextWidget(
                  text: "Cancelar",
                  textColor: AppColors.white,
                  backgroundColor: AppColors.red_300,
                  width: 100,
                  action: () => Get.back(),
                ),
                ButtonTextWidget(
                  text: "Salvar",
                  icon: Icons.save,
                  iconSize: 25,
                  width: 100,
                  action: (){},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}