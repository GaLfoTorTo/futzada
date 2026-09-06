import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/providers/escalation/escalation_team_provider.dart';
import 'package:esportly/presentation/widget/dialogs/dialog_capitan.dart';
import 'package:esportly/presentation/widget/dialogs/dialog_escalation_confirm.dart';

class FloatButtonEscalationWidget extends ConsumerWidget {
  const FloatButtonEscalationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ESTADOS - ESTILIZAÇÃO
    final dimensions = MediaQuery.of(context).size;
    final team = ref.watch(escalationTeamProvider);

    final startersFull = team.starters.isNotEmpty && !team.starters.contains(null);
    final reservesFull = team.reserves.isNotEmpty && !team.reserves.contains(null);
    final allFull = startersFull && reservesFull;
    final hasCapitan = team.capitan != 0;

    // Não exibir até titulares e reservas completos
    if (!allFull) return const SizedBox.shrink();

    final needsCapitan = !hasCapitan;

    return SizedBox(
      width: needsCapitan ? 70 : dimensions.width * 0.92,
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
          borderRadius: BorderRadius.circular(15)),
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
            : Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.assignment_turned_in_rounded, size: 30, color: AppColors.blue_500),
                  Text(
                    'Confirmar',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.blue_500
                    ),
                  )
                ],
              )
      ),
    );
  }
}
