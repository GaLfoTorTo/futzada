import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/data/services/escalation_service.dart';
import 'package:esportly/presentation/widget/buttons/button_player_widget.dart';
import 'package:esportly/core/providers/escalation/escalation_market_provider.dart';

class ReserveBankWidget extends ConsumerWidget {
  final String category;
  final List<int?> players;

  const ReserveBankWidget({
    super.key, 
    required this.category,
    required this.players,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = MediaQuery.of(context).size;
    final managerSession = ref.watch(escalationMarketProvider);
    final escalationService = EscalationService();

    return Card(
      child: Container(
        width: dimensions.width - 20,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: players.asMap().entries.map((item) {
            UserModel? user = managerSession.playersMarket.where((i) => i.id == item.value).firstOrNull;
            final String position = escalationService.getReservePosition(item.key, category);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonPlayerWidget(
                  user: user,
                  position: position,
                  index: item.key,
                  occupation: 'reserves',
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    position.toUpperCase(),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: AppColors.grey_300),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
