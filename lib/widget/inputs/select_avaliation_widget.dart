import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:get/get.dart';

class SelectAvaliationWidget extends StatelessWidget {
  final int value;
  final Function onChanged;

  const SelectAvaliationWidget({
    super.key,
    required this.value,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    final color = Get.isDarkMode ? AppColors.dark_300 : AppColors.white;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (star){
          star++;
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => onChanged(star),
            child: Container(
              alignment: Alignment.center,
              width: 55,
              height: 55,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                AppIcones.star_solid,
                color: value >= star ? AppColors.yellow_300 : AppColors.gray_300,
                size: 30,
              ),
            ),
          );
        }).toList()
      )
    );
  }
}