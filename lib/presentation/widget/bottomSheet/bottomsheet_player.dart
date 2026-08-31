import 'package:esportly/core/helpers/player_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/data/models/player_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';

class BottomSheetPlayer extends ConsumerStatefulWidget {
  final UserModel user;

  const BottomSheetPlayer({super.key, required this.user});

  @override
  ConsumerState<BottomSheetPlayer> createState() => BottomSheetPlayerState();
}

class BottomSheetPlayerState extends ConsumerState<BottomSheetPlayer> {
  bool isCapitan = false;

  @override
  void initState() {
    super.initState();
    final team = ref.read(escalationTeamProvider);
    isCapitan = team.selectedPlayerCapitan == widget.user.id;
  }

  void setPlayerPosition(id, action) {
    if (action == 'setPosition') {
      ref.read(escalationSessionProvider.notifier).setPlayerEscalation(id);
    } else {
      ref.read(escalationTeamProvider.notifier).setPlayerCapitan(id);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = MediaQuery.of(context).size;
    final session = ref.watch(escalationSessionProvider);
    final user = widget.user;
    final PlayerModel player = user.player!;
    final Map<String, dynamic> playerMap = player.toMap();
    final String modality = session.event!.modality!.name;
    final mainPos = player.getMainPosition(modality);
    final List secondaryPositions = player.getSecondaryPositions(modality);

    final List<Map<String, dynamic>> metrics = [
      {'name': 'price', 'label': 'Valor de Mercado', 'icon': AppIcones.money_check_solid, 'price': true},
      {'name': 'valuation', 'label': 'Valorização', 'icon': AppIcones.sort_amount_up_solid, 'price': false},
      {'name': 'points', 'label': 'Última Pontuação', 'icon': AppIcones.calculator_solid, 'price': false},
      {'name': 'avarage', 'label': 'Média', 'icon': AppIcones.chart_line_solid, 'price': false},
      {'name': 'games', 'label': 'Jogos', 'icon': AppIcones.clipboard_solid, 'price': false},
      {'name': 'status', 'label': 'Status', 'icon': AppIcones.user_checked_solid, 'price': false},
    ];

    return Container(
      height: (dimensions.height / 2) + 60,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogTheme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Column(
                children: [
                  ImgCircularWidget(
                    size: 100,
                    image: user.photo,
                    borderColor: PlayerHelper.setColorPosition(mainPos?.alias),
                  ),
                  Text(
                    UserHelper.getFullName(user),
                    style: Theme.of(context).textTheme.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text("@${user.userName}", style: Theme.of(context).textTheme.bodyMedium),
                  if (mainPos != null) PositionWidget(position: mainPos.alias, mainPosition: true),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: secondaryPositions.map((pos) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: PositionWidget(position: pos.alias, mainPosition: false),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              if (isCapitan) ...[
                const Positioned(
                  top: 70,
                  left: 80,
                  child: PositionWidget(
                    position: "cap",
                    mainPosition: true,
                    width: 35,
                    height: 25,
                    textSide: 10,
                  ),
                ),
              ],
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Wrap(
              spacing: 10,
              children: metrics.map((item) {
                final name = item['name'];
                return Container(
                  width: (dimensions.width / 2) - 25,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.grey_300.withAlpha(40),
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Column(
                    children: [
                      if (name == 'status') ...[
                        Icon(
                          AppHelper.setStatusPlayer(
                            UserHelper.getParticipant(
                              user.participants,
                              session.event!.id!,
                            )!.status,
                          )['icon'],
                          size: 30,
                          color: AppHelper.setStatusPlayer(
                            UserHelper.getParticipant(
                              user.participants,
                              session.event!.id!,
                            )!.status,
                          )['color'],
                        ),
                      ] else ...[
                        Text(
                          "${playerMap['rating'][name]}",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: AppHelper.setColorPontuation(playerMap['rating'][name])['color'],
                          ),
                        ),
                      ],
                      Text(
                        "${item['label']}",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonTextWidget(
                text: !isCapitan ? "Tornar Capitão" : "Remover Capitão",
                icon: Icons.copyright,
                width: (dimensions.width / 2) - 40,
                height: 30,
                backgroundColor: AppColors.yellow_300,
                textColor: AppColors.dark_500,
                action: () => setPlayerPosition(player.id, 'setCapitan'),
              ),
              ButtonTextWidget(
                text: "Remover",
                icon: AppIcones.trash_solid,
                width: (dimensions.width / 2) - 40,
                height: 30,
                backgroundColor: AppColors.red_300,
                textColor: AppColors.white,
                action: () => setPlayerPosition(player.id, 'setPosition'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
