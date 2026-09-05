import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/event_helper.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/images/img_group_circle_widget.dart';

class DialogEscalationConfirm extends ConsumerWidget {
  const DialogEscalationConfirm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = MediaQuery.of(context).size;
    final session = ref.watch(escalationSessionProvider);
    final team = ref.watch(escalationTeamProvider);

    final int i = team.starters.firstWhere((p) => p == team.selectedPlayerCapitan)!;
    final UserModel capitan = EventHelper.getUserEvent(session.event!, i)!;

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Confirmar Escalação ?',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Text(
              'Confirme a escalação do time para a próxima rodada. Após confirmar você poderá fazer alterações na sua equipe até o início da rodada.',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.grey_500),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: dimensions.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Formação:', style: Theme.of(context).textTheme.titleSmall),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: AppColors.green_300,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          session.formation,
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppColors.blue_500
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Titulares:', style: Theme.of(context).textTheme.titleSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: ImgGroupCircularWidget(
                          size: 30,
                          side: "right",
                          images: team.starters
                              .take(3)
                              .map((i) => EventHelper.getUserEvent(session.event!, i!)?.photo)
                              .toList(),
                        ),
                      ),
                      Text(
                        '+ ${team.starters.length - 3}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.grey_500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Reservas:', style: Theme.of(context).textTheme.titleSmall),
                      if (!team.reserves.contains(null)) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: ImgGroupCircularWidget(
                            size: 30,
                            side: "right",
                            images: team.reserves
                                .take(3)
                                .map((i) => EventHelper.getUserEvent(session.event!, i!)?.photo)
                                .toList(),
                          ),
                        ),
                      ] else ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          child: Text(
                            'Reservas não escalados',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.grey_500),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    children: [
                      Text('Capitão:', style: Theme.of(context).textTheme.titleSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Row(
                          children: [
                            ImgCircularWidget(
                              size: 30,
                              image: capitan.photo,
                              borderColor: AppColors.yellow_200,
                            ),
                            Container(
                              width: dimensions.width * 0.4,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    UserHelper.getFullName(capitan),
                                    style: Theme.of(context).textTheme.labelLarge,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                            const PositionWidget(
                              position: "CAP",
                              mainPosition: true,
                              width: 35,
                              height: 25,
                              textSide: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ButtonTextWidget(
              text: "Salvar",
              iconSize: 15,
              icon: AppIcones.save_solid,
              width: dimensions.width,
              height: 30,
              action: () async {
                Navigator.of(context).pop();
                await ref.read(escalationSessionProvider.notifier).saveEscalation();
              },
              backgroundColor: AppColors.green_300,
              textColor: AppColors.blue_500,
            ),
          ],
        ),
      ),
    );
  }
}
