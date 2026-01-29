import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class CardInfoWidget extends StatelessWidget {
  final String description;
  const CardInfoWidget({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.symmetric(vertical: BorderSide(width: 5, color: Theme.of(context).primaryColor)),
        ),
        child: Row(
          spacing: 10,
          children: [
            const Icon(
              Icons.info_outline,
              color: AppColors.blue_500,
            ),
            Expanded(
              child: Text(
                description,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}