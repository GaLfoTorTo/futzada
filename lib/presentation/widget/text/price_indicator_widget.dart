import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

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
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.bold
          )
        ),
        Text.rich(
          TextSpan(
            text: 'Fz\$: ',
            style: const TextStyle(
              fontSize: 10, 
              color: AppColors.grey_700
            ),
            children: [
              TextSpan(
                text: value,
                style: Theme.of(context).textTheme.displayMedium
              ),
            ]
          )
        ),
      ],
    );
  }
}