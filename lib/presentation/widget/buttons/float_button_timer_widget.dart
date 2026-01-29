import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class FloatButtonTimerWidget extends StatelessWidget {
  final VoidCallback actionButton;
  final bool isRunning;
  const FloatButtonTimerWidget({
    super.key,
    required this.actionButton,
    required this.isRunning
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        key: const ValueKey('fab-partidas'),
        onPressed: actionButton,
        enableFeedback: true,
        backgroundColor: AppColors.green_300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: Icon(
          isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: AppColors.blue_500,
          size: 50,
        ),
      ),
    );
  }
}