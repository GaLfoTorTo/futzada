import 'package:esportly/core/providers/escalation/escalation_market_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/models/player_model.dart';
import 'package:esportly/data/models/rating_model.dart';
import 'package:esportly/core/helpers/modality_helper.dart';
import 'package:esportly/core/helpers/user_helper.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/presentation/widget/images/img_circle_widget.dart';
import 'package:esportly/presentation/widget/bottomSheet/bottomsheet_player.dart';
import 'package:esportly/presentation/widget/indicators/indicator_valuation_widget.dart';

class ButtonPlayerWidget extends ConsumerWidget {
  final int index;
  final String occupation;
  final String position;
  final UserModel? user;
  final bool? capitan;
  final int? grupoPosition;
  final Color borderColor;
  final double? size;
  final bool? userDefault;
  final bool? showName;

  const ButtonPlayerWidget({
    super.key,
    required this.index,
    required this.occupation,
    required this.position,
    this.user,
    this.capitan = false,
    this.grupoPosition,
    this.borderColor = AppColors.white,
    this.size = 55,
    this.userDefault = false,
    this.showName = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(escalationSessionProvider);

    //FUNÇÃO DE DFINIÇÃO DE SELEÇÃO DE JOGADOR
    void selectPlayer(UserModel? user) {
      ref.read(escalationTeamProvider.notifier).setSelectedPlayer(index, occupation);
      if (user != null) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          builder: (_) => BottomSheetPlayer(user: user),
        );
      } else {
        final marketNotifier = ref.read(escalationMarketProvider.notifier);
        marketNotifier.setFilter('positions', [position]);

        if (occupation == 'reserves') {
          // Calcular preço do titular mais barato para limitar o mercado de reservas
          final team = ref.read(escalationTeamProvider);
          final market = ref.read(escalationMarketProvider);
          final eventId = session.event?.id;
          final starterPrices = team.starters
              .where((id) => id != null)
              .map((id) {
                final starter = market.playersMarket.where((u) => u.id == id).firstOrNull;
                return starter?.player?.ratings
                    ?.firstWhere((r) => r.eventId == eventId, orElse: () => starter.player!.ratings!.first)
                    .price;
              })
              .whereType<double>()
              .toList();
          final cheapestPrice = starterPrices.isNotEmpty
              ? starterPrices.reduce((a, b) => a < b ? a : b)
              : null;
          marketNotifier.setFilter('maxPrice', cheapestPrice);
        } else {
          marketNotifier.setFilter('maxPrice', null);
        }

        context.push('/escalation/market');
      }
    }

    //FUNÇÃO DE DEFINIÇÃO DE BOTÃO DE JOGADOR
    List<Widget> setPlayerButton(UserModel? user) {
      final style = ModalityHelper.getEventModalityColor(session.event!.modality?.name ?? '');
      final color = Theme.of(context).brightness == Brightness.dark ? AppColors.dark_300 : AppColors.white;

      if (user != null) {
        final PlayerModel player = user.player!;
        final RatingModel rating = UserHelper.getRating(player, session.event!.id!);

        return [
          if (rating.points != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_300.withAlpha(50),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: IndicatorValuationWidget(points: rating.points),
            ),
          ],
          InkWell(
            onTap: () => selectPlayer(user),
            child: ImgCircularWidget(size: size!, image: user.photo, borderColor: borderColor),
          ),
          if (showName!) ...[
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
              decoration: BoxDecoration(
                color: AppColors.dark_500.withAlpha(90),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                UserHelper.getFullName(user),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: AppColors.white
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ];
      } else {
        return [
          InkWell(
            onTap: () => selectPlayer(user),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: style['color'],
                gradient: LinearGradient(
                  colors: [style['color'], style['bg']],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(color: AppColors.white, width: 2),
                borderRadius: BorderRadius.circular(size! / 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_300.withAlpha(50),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 40),
            ),
          ),
        ];
      }
    }

    return SizedBox(
      height: user != null ? size! + 50 : size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: setPlayerButton(user),
      ),
    );
  }
}
