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

  //ALTURA DO CONTAINER AJUSTADA POR FAMÍLIA DE ESPORTE
  double _courtHeight(String category) {
    switch (category) {
      case 'Basquete':
      case 'Streetball':
        return height! + 10;
      case 'Volei':
      case 'Volei de Praia':
      case 'Fut Volei':
        return height! + 30;
      default:
        return height! + 60;
    }
  }

  // ALINHAMENTO VERTICAL DA COLUNA: evita que poucas linhas sejam empurradas
  // às extremidades opostas do container
  MainAxisAlignment _columnAlignment(int rowCount) {
    if (rowCount <= 2) return MainAxisAlignment.spaceEvenly;
    if (rowCount == 3) return MainAxisAlignment.spaceAround;
    return MainAxisAlignment.spaceBetween;
  }

  // ALINHAMENTO HORIZONTAL DA LINHA: 4+ players ocupam toda a largura;
  // grupos menores ficam centrados com espaçamento uniforme nas bordas
  MainAxisAlignment _rowAlignment(int playerCount) {
    if (playerCount >= 4) return MainAxisAlignment.spaceBetween;
    return MainAxisAlignment.spaceEvenly;
  }

  // PADDING LATERAL POR GRUPO: aperta grupos pequenos para evitar que fiquem
  // visualmente colados nas bordas do container quando há poucos players
  EdgeInsets _rowPadding(int playerCount) {
    if (playerCount == 1) return const EdgeInsets.symmetric(horizontal: 20);
    if (playerCount == 2) return const EdgeInsets.symmetric(horizontal: 10);
    return EdgeInsets.zero;
  }

  //ALIAS DE POSIÇÃO — TRATA POSIÇÕES COMPOSTAS COM HÍFEN (EX: ALA-PIVÔ → 'ala')
  String _positionAlias(String position) {
    final part = position.split('-').first;
    final len = part.length.clamp(0, 3);
    return part.characters.getRange(0, len).toLowerCase().toString();
  }

  List<Widget> _buildPlayers(EscalationSessionState managerSession, EscalationTeamState team) {
    final escalationService = EscalationService();
    final formations = escalationService.getFormationLayout(managerSession.category, managerSession.formation);
    final players = <Widget>[];
    int playerIndex = -1;

    formations.asMap().forEach((sectorIndex, playersInGroup) {
      players.add(
        Padding(
          padding: _rowPadding(playersInGroup),
          child: Row(
            mainAxisAlignment: _rowAlignment(playersInGroup),
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
              final String positionAlias = _positionAlias(position);
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

    final formations = EscalationService().getFormationLayout(
      managerSession.category,
      managerSession.formation,
    );

    return Container(
      width: width,
      height: _courtHeight(managerSession.category),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: _columnAlignment(formations.length),
        children: _buildPlayers(managerSession, team),
      ),
    );
  }
}
