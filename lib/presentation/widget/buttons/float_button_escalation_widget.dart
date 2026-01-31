import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/widget/badges/position_widget.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_capitan.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_escalation_confirm.dart';

class FloatButtonEscalationWidget extends StatelessWidget {
  final bool hasCapitan;
  const FloatButtonEscalationWidget({
    super.key,
    required this.hasCapitan,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        key: const ValueKey('fab-escalation'),
        onPressed: () => Get.dialog(hasCapitan
          ? const DialogEscalationConfirm()
          : const DialogCapitan(),
        ),
        enableFeedback: true,
        tooltip: hasCapitan ? 'Confirmar escalação' : 'Selecionar capitão',
        backgroundColor: hasCapitan ? AppColors.green_300 : AppColors.yellow_200,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: hasCapitan 
          ? const Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                AppIcones.clipboard_solid,
                size: 32,
                color: AppColors.blue_500,
              ),
              Positioned(
                bottom: 8,
                child: Icon(
                  AppIcones.check_solid,
                  size: 10,
                  color: AppColors.green_300,
                ),
              ),
            ]
          )
          : const PositionWidget(
              position: "CAP",
              mainPosition: true,
              width: 35,
              height: 25,
              textSide: 10,
            ),
        )
    );
  }
}