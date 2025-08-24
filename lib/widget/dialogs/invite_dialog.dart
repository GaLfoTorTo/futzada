import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/controllers/event_controller.dart';

class IniviteDialog extends StatelessWidget {
  final Map<String, bool> invite;
  const IniviteDialog({
    super.key,
    required this.invite
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLER DE EVENTO
    EventController eventController = EventController.instance;

    //FUNÇÃO PARA RESGATAR ICONE
    IconData iconInvite(String key){
      switch (key) {
        case "Jogador":
          return AppIcones.foot_futebol_solid;
        case "Técnico":
          return AppIcones.clipboard_solid;
        case "Arbitro":
          return AppIcones.apito;
        case "Colaborador":
          return AppIcones.users_solid;
        default:
          return AppIcones.foot_futebol_solid;
      }
    }

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'invite',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Determine o formato de ingresso dos participantes a pelada, as pré-definições aplicadas poderão ser alteradas posteriormente.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.gray_500),
                textAlign: TextAlign.center,
              ),
            ),
            Obx(() {
              return Column(
                children: invite.entries.map((item) {
                  final icon = iconInvite(item.key);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SwitchListTile(
                      value: item.value,
                      onChanged: (newValue) => eventController.invite[item.key] = !item.value,
                      activeColor: AppColors.green_300,
                      inactiveTrackColor: AppColors.gray_300,
                      inactiveThumbColor: AppColors.gray_500,
                      title: Text(
                        item.key,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: item.value ? AppColors.green_300 : AppColors.gray_500,
                        ),
                      ),
                      secondary:  Icon(
                        icon,
                        color: item.value ? AppColors.green_300 : AppColors.gray_500,
                        size: item.key == "Jogador" ? 15 : 25,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonTextWidget(
                  text: "Cancelar",
                  width: 70,
                  height: 20,
                  action: () => Get.back(),
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.gray_500,
                ),
                ButtonTextWidget(
                  text: "Definir",
                  width: 50,
                  height: 20,
                  action: () => Get.back(),
                  backgroundColor: Colors.transparent,
                  textColor: AppColors.green_300,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}