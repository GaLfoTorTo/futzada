import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class IndicatorFormWidget extends StatelessWidget {
  final int length;
  final int etapa;
  const IndicatorFormWidget({
    super.key, 
    required this.length,
    required this.etapa
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(length, (i) {
          bool isActive = i <= etapa;
          return Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.green_300 : AppColors.grey_500,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${i + 1}',
                    style: TextStyle(
                      color: isActive ? AppColors.blue_500 : AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (i < length - 1)
                Container(
                  height: 5,
                  width: 30,
                  color: i < etapa ? AppColors.green_300 : AppColors.grey_500,
                )
            ],
          );
        }),
      ),
    );
  }
}