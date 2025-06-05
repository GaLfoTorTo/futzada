import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/dialogs/event_games_dialog.dart';
import 'package:get/get.dart';

class FloatButtonEventWidget extends StatelessWidget {
  final int index;
  const FloatButtonEventWidget({
    super.key,
    required this.index
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        key: const ValueKey('fab-partidas'),
        onPressed: () => Get.bottomSheet(EventGamesDialog()),
        enableFeedback: true,
        tooltip: 'Iniciar partida',
        backgroundColor: AppColors.green_300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          color: AppColors.blue_500,
          size: 50,
        ),
      )
    );
  }
}