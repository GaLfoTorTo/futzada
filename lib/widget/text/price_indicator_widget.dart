import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class PriceIndicatorWidget extends StatelessWidget {
  final String title;
  final String value;

  const PriceIndicatorWidget({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.gray_500,
            fontSize: 10,
          ),
        ),
        Text.rich(
          TextSpan(
            text: 'Fz\$: ',
            style: const TextStyle(
              fontSize: 10, 
              color: AppColors.gray_700
            ),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: AppColors.dark_500,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]
          )
        ),
      ],
    );
  }
}