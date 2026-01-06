import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:get/get.dart';

class SelectRoundedWidget extends StatelessWidget {
  final String value;
  final Color? color;
  final double? size;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final bool checked;
  final Function onChanged;

  const SelectRoundedWidget({
    super.key,
    required this.value,
    this.color,
    this.size = 130,
    required this.icon,
    this.iconColor = AppColors.white,
    this.iconSize = 100,
    required this.checked,
    required this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    List<IconData>list = [
      AppIcones.foot_futebol_solid,
      AppIcones.foot_fut7_solid,
      AppIcones.foot_futsal_solid,
    ];
    //COR DO COMPONENTE
    final color = Get.isDarkMode ? AppColors.dark_300 : AppColors.gray_300;

    return InkWell(
      onTap: () => onChanged(value),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: checked ? AppColors.green_300 : color,
              borderRadius: BorderRadius.circular(80),
              boxShadow: [
                if (checked == true )
                  BoxShadow(
                    color: AppColors.green_300.withOpacity(0.2),
                    spreadRadius: 8,
                    blurRadius: 1,
                    offset: Offset(0,0),
                  ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: list.contains(icon)
              ? Transform.rotate(
                  angle: - 45 * 3.14159 / 200,
                  child: Icon(
                    icon,
                    color: checked ? AppColors.blue_500 : iconColor,
                    size: iconSize,
                  ),
                ) 
              :
                Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: checked ? AppColors.green_300 : null
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}