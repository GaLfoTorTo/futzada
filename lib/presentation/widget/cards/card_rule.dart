import 'package:flutter/material.dart';
import 'package:futzada/data/models/rule_model.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/bottomSheet/bottomsheet_rule.dart';
import 'package:get/get.dart';

class CardRule extends StatelessWidget {
  final RuleModel rule;
  const CardRule({
    super.key,
    required this.rule,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return TextButton(
      onPressed: () => Get.bottomSheet(BottomSheetRule(rule: rule), isScrollControlled: true),
      child: Container(
        width: dimensions.width,
        padding: const EdgeInsets.all(10),
        child: Row(
          spacing: 10,
          children: [
            const Icon(
              Icons.sports,
              color: AppColors.white,
              size: 30,
            ),
            Text(
              rule.title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.white),
            )
          ],
        ),
      ),
    );
  }
}