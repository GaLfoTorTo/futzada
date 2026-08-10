import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class IndicatorLoadingWidget extends StatelessWidget {
  const IndicatorLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsGeometry.only(top: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.dark_500 : AppColors.white,
        borderRadius: BorderRadius.circular(50)
      ),
      child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),
    );
  }
}