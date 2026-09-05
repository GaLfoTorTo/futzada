import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/presentation/widget/dialogs/dialog_capitan.dart';
import 'package:esportly/presentation/widget/dialogs/dialog_escalation_confirm.dart';

class FloatButtonEscalationWidget extends ConsumerWidget {
  const FloatButtonEscalationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(escalationTeamProvider);

    final startersFull = team.starters.isNotEmpty && !team.starters.contains(null);
    final reservesFull = team.reserves.isNotEmpty && !team.reserves.contains(null);
    final allFull = startersFull && reservesFull;
    final hasCapitan = team.selectedPlayerCapitan != 0;

    // Não exibir até titulares e reservas completos
    if (!allFull) return const SizedBox.shrink();

    final needsCapitan = !hasCapitan;

    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        key: ValueKey(needsCapitan ? 'fab-capitan' : 'fab-confirm'),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => needsCapitan
            ? const DialogCapitan()
            : const DialogEscalationConfirm(),
        ),
        enableFeedback: true,
        tooltip: needsCapitan ? 'Selecionar capitão' : 'Confirmar escalação',
        backgroundColor: needsCapitan ? AppColors.yellow_200 : AppColors.green_300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(needsCapitan ? 15 : 45)),
        child: needsCapitan
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: List.generate(2, (i) => Container(height: 5, width: 15, color: AppColors.dark_500,))
                  ),
                  Text(
                    'C',
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: AppColors.dark_700
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 10,
                    children: List.generate(2, (i) => Container(height: 5, width: 15, color: AppColors.dark_500,))
                  ),
                ]
              )
            : const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(AppIcones.clipboard_solid, size: 32, color: AppColors.blue_500),
                  Positioned(
                    bottom: 8,
                    child: Icon(AppIcones.check_solid, size: 10, color: AppColors.green_300),
                  ),
                ],
              ),
      ),
    );
  }
}
