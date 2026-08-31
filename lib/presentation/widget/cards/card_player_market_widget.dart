import 'package:esportly/core/enum/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/data/models/participant_model.dart';
import 'package:esportly/data/models/rating_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/player_model.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';

class CardPlayerMarketWidget extends ConsumerWidget {
  final UserModel user;
  final ParticipantModel participant;
  final String modality;

  const CardPlayerMarketWidget({
    super.key,
    required this.user,
    required this.participant,
    required this.modality,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = MediaQuery.of(context).size;
    final managerSession = ref.watch(escalationSessionProvider);
    final PlayerModel player = user.player!;
    final RatingModel rating = player.ratings != null && player.ratings!.isNotEmpty
      ? player.ratings![0] : 
      RatingModel(
        id: 1,
        eventId: participant.eventId,
        userId: user.id,
        role: Roles.Player,
      );
    final Map<String, dynamic> playerMap = player.toMap();
    final String modality = managerSession.event!.modality!.name;
    final mainPosition = player.getMainPosition(modality);
    final secondaryPositions = player.getSecondaryPositions(modality);
    
    //FUNÇÃO DE DEFINIÇÃO STYLES  
    final stylePlayer = AppHelper.setStatusPlayer(participant.status);
    final styleRating = AppHelper.setColorPontuation(rating.valuation);

    //FUNÇÃO DE DEFINIÇÃO DE BOTÕES
    Map<String, dynamic> setButtonBuy(PlayerModel player) {
      final isEscaled = ref.read(escalationTeamProvider.notifier).findPlayerEscalation(player.id!);
      if (rating.price! > managerSession.patrimony) return {'text': 'Comprar', 'color': AppColors.grey_300, 'disabled': true};
      if (isEscaled) return {'text': 'Vender', 'color': AppColors.red_300, 'disabled': false};
      return {'text': 'Comprar', 'color': AppColors.green_300, 'disabled': false};
    }
    
    //FUNÇÃO DE DEFINIÇÃO DE POSIÇÃO DO JOGADOR
    void setPlayerPosition(uuid) {
      ref.read(escalationSessionProvider.notifier).setPlayerEscalation(uuid);
      Navigator.of(context).pop();
    }

    //FUNÇÃO DE DEFINIÇÃO DE OPÇÕES DE METRICAS
    final Map<String, dynamic> metrics = {
      'points': 'Última pontuação',
      'avarage': 'Media',
      'games': 'jogos',
    };

    //FUNÇÃO DE CONFIGURAÇÕES DE BOTÕES
    final buttonConfig = setButtonBuy(player);

    return Card(
      child: Container(
        width: dimensions.width,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(
              width: dimensions.width * 0.6,
              child: Column(
                spacing: 10,
                children: [
                  Row(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImgCircularWidget(
                        size: 70,
                        image: user.photo,
                        borderColor: AppColors.grey_300,
                      ),
                      Expanded(
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              UserHelper.getFullName(user),
                              style: Theme.of(context).textTheme.titleSmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "@${user.userName}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: AppColors.grey_300),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (mainPosition != null)
                                  PositionWidget(
                                    position: mainPosition.alias,
                                    mainPosition: true,
                                    width: 40,
                                    height: 25,
                                  ),
                                ...secondaryPositions.map((pos) {
                                  return PositionWidget(
                                    position: pos.alias,
                                    mainPosition: false,
                                    width: 25,
                                    height: 20,
                                    textSide: 8,
                                  );
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: dimensions.width * 0.6,
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: metrics.entries.map((entry) {
                        final key = entry.key;
                        final label = entry.value;
                        final itemWidth = key == 'points'
                            ? (dimensions.width * 0.60)
                            : (dimensions.width * 0.3) - 5;
                        return Container(
                          width: itemWidth,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.grey_300.withAlpha(40),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "${playerMap['ratings'][0][key] ?? 0.0}",
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                  color: AppHelper.setColorPontuation(
                                    playerMap['ratings'][0][key],
                                  )['color'],
                                ),
                              ),
                              Text(
                                "$label",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: (dimensions.width * 0.3) - 10,
              height: 210,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Icon(
                      stylePlayer['icon'],
                      color: stylePlayer['color'],
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Fz\$",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.grey_300),
                        ),
                        Text("${rating.price}", style: Theme.of(context).textTheme.headlineLarge),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                "${rating.valuation}",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: styleRating['color'],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Icon(
                              styleRating['icon'],
                              size: 15,
                              color: styleRating['color'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ButtonTextWidget(
                    text: buttonConfig['text'],
                    height: 30,
                    width: (dimensions.width * 0.3) - 10,
                    textColor: AppColors.white,
                    backgroundColor: buttonConfig['color'],
                    disabled: buttonConfig['disabled'],
                    action: () => setPlayerPosition(player.id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
