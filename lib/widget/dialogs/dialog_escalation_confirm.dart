import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:futzada/controllers/escalation_controller.dart';

class DialogEscalationConfirm extends StatelessWidget {
  const DialogEscalationConfirm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR INSTÂNCIA DO CONTROLLER DE ESCALAÇÃO
    EscalationController escalationController = EscalationController.instance;
    ParticipantModel capitan = escalationController.starters.firstWhere((p) => p?.id == escalationController.selectedPlayerCapitan.value)!;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Confirmar Escalação ?',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Confirme a escalação do time para a próxima rodada. Após confirmar você poderá fazer alterações na sua equipe até o início da rodada.',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.gray_500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: dimensions.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Formação:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.green_300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          '${escalationController.selectedFormation.value}',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ]
                  ),
                  Row(
                    children: [
                      Text(
                        'Titulares:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ImgGroupCircularWidget(
                          width: 30,
                          height: 30,
                          side: "right",
                          images: escalationController.starters.take(3).map((item) => item?.user.photo).toList()
                        ),
                      ),
                      Text(
                        '+ ${escalationController.starters.length - 3}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      ),
                    ]
                  ),
                  Row(
                    children: [
                      Text(
                        'Reservas:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if(!escalationController.reserves.contains(null))...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: ImgGroupCircularWidget(
                            width: 30,
                            height: 30,
                            side: "right",
                            images: escalationController.reserves.map((item) => item?.user.photo).toList()
                          ),
                        ),
                      ]else...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            'Reservas não escalados',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.gray_500),
                          ),
                        ),
                      ]
                    ]
                  ),
                  Row(
                    children: [
                      Text(
                        'Capitão:',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          children: [
                            ImgCircularWidget(
                              height: 30,
                              width: 30,
                              image: capitan.user.photo,
                              borderColor: AppColors.yellow_200
                            ),
                            Container (
                              width: dimensions.width * 0.4,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${capitan.user.firstName} ${capitan.user.lastName}",
                                    style: Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            SvgPicture.asset(
                              AppIcones.posicao['cap']!,
                              width: 20,
                              height: 20,
                            ),
                          ],
                        )
                      ),
                    ]
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ButtonTextWidget(
                text: "Salvar",
                iconSize: 15,
                icon: AppIcones.save_solid,
                width: dimensions.width,
                height: 30,
                action: () => Get.back(),
                backgroundColor: AppColors.green_300,
                textColor: AppColors.blue_500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}