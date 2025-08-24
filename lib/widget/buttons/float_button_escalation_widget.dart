import 'package:futzada/widget/dialogs/escalation_confirm_dialog.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/widget/dialogs/escalation_capitan_dialog.dart';

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
          ? const EscalationConfirmDialog()
          : const EscalationCapitanDialog(),
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
          : SvgPicture.asset(
              AppIcones.posicao['cap']!,
              width: 38,
              height: 38,
            ),
        )
    );
  }
}