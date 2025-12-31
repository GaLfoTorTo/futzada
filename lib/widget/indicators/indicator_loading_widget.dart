import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class IndicatorLoadingWidget extends StatelessWidget {
  const IndicatorLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsGeometry.only(top: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(50)
      ),
      child: const CircularProgressIndicator(color: AppColors.green_300,),
    );
  }
}