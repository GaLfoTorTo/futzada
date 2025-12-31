import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class FloatButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color color;
  final String floatKey;

  const FloatButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.floatKey,
    this.color = AppColors.green_300,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        heroTag: floatKey,
        onPressed: onPressed,
        enableFeedback: true,
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: Icon(
          icon,
          color: AppColors.blue_500,
          size: 30,
        ),
      )
    );
  }
}