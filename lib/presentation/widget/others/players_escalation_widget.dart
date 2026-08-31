import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/helpers/player_helper.dart';
import 'package:esportly/core/helpers/event_helper.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/data/services/escalation_service.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_player_widget.dart';

class PlayersEscalationWidget extends ConsumerWidget {
  final double? width;
  final double? height;

  const PlayersEscalationWidget({
    super.key,
    this.width = 342,
    this.height = 518,
  });

  List<Row> _buildPlayers(EscalationSessionState managerSession, EscalationTeamState team) {
    final escalationService = EscalationService();
    final formations = escalationService.getFormation(managerSession.formation);
    final players = <Row>[];
    int playerIndex = -1;

    formations.toList().asMap().forEach((sectorIndex, playersInGroup) {
      players.add(
        Row(
          mainAxisAlignment: playersInGroup == 1 || playersInGroup == 2
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.spaceBetween,
          children: List.generate(playersInGroup, (key) {
            playerIndex = playerIndex + 1;
            final String position = escalationService.getPositionName(
              sectorIndex,
              managerSession.category,
              managerSession.formation,
            );
            UserModel? user;
            if (playerIndex < team.starters.length && team.starters[playerIndex] != null) {
              user = EventHelper.getUserEvent(managerSession.event!, team.starters[playerIndex]!);
            }
            final String positionAlias =
                position.characters.getRange(0, 3).toLowerCase().toString();
            final borderColor = PlayerHelper.setColorPosition(positionAlias);

            if (team.selectedPlayerCapitan == user?.id) {
              return Stack(
                children: [
                  ButtonPlayerWidget(
                    index: playerIndex,
                    grupoPosition: sectorIndex,
                    occupation: 'starters',
                    position: positionAlias,
                    user: user,
                    capitan: true,
                    size: 60,
                    borderColor: borderColor,
                    showName: true,
                  ),
                  const Positioned(
                    top: 50,
                    left: 0,
                    child: PositionWidget(
                      position: "CAP",
                      mainPosition: true,
                      width: 35,
                      height: 25,
                      textSide: 10,
                    ),
                  ),
                ],
              );
            } else {
              return ButtonPlayerWidget(
                index: playerIndex,
                grupoPosition: sectorIndex,
                occupation: 'starters',
                position: positionAlias,
                user: user,
                size: 60,
                borderColor: borderColor,
                showName: true,
              );
            }
          }),
        ),
      );
    });
    return players;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final managerSession = ref.watch(escalationSessionProvider);
    final team = ref.watch(escalationTeamProvider);

    if (!managerSession.isReady || team.starters.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: width,
      height: height! + 60,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildPlayers(managerSession, team),
      ),
    );
  }
}
