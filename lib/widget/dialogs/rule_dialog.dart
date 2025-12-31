import 'package:flutter/material.dart';
import 'package:futzada/models/rule_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';

class RuleDialog extends StatefulWidget {
  final RuleModel? rule;
  const RuleDialog({
    super.key,
    this.rule,
  });

  @override
  State<RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<RuleDialog> {
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

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
      ),
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
            bgColor: AppColors.gray_300.withAlpha(60),
            type: TextInputType.text,
          ),
        ],
      ),
    );
  }
}