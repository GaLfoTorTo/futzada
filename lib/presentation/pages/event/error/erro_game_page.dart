import 'package:esportly/core/providers/game/game_schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErroGamePage extends ConsumerWidget {
  const ErroGamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    final gameSession = ref.read(gameScheduleProvider.notifier);
    //DEFINIR COR APARTIR DO TEMA
    final backgroundColor = Theme.of(context).brightness == Brightness.dark ? AppColors.dark_500 : AppColors.white;

    return  Container(
      width: dimensions.width,
      height: dimensions.height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor.withAlpha(50),
            backgroundColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Sua pelada não tem nenhuma partida agendada',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(
            Icons.play_disabled_rounded,
            size: 200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Parece que sua peladas não tem nenhuma partida ao vivo ou agendada. Inicie uma nova partida agora ou entre em contato com o organizador ou colaboradores da pelada.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              ButtonTextWidget(
                text: "Recarregar",
                width: dimensions.width,
                icon: Icons.restart_alt_rounded,
                iconSize: 30,
                action: () => gameSession.getGames(),
              ),
            ],
          )
        ],
      ),
    );
  }
}