import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class FloatButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String floatKey;
  final Color backgroundColor;
  final Color color;

  const FloatButtonWidget({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.floatKey,
    this.backgroundColor = AppColors.green_300,
    this.color = AppColors.blue_500,
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
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
        child: Icon(
          icon,
          color: color,
          size: 30,
        ),
      )
    );
  }
}