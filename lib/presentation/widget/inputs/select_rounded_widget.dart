import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:get/get.dart';

class SelectRoundedWidget extends StatelessWidget {
  final String? label;
  final String value;
  final double? size;
  final IconData icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? iconSize;
  final bool checked;
  final Function onChanged;
  final Function? onDoubleChanged;

  const SelectRoundedWidget({
    super.key,
    this.label,
    required this.value,
    required this.icon,
    this.size = 130,
    this.iconSize = 100,
    this.backgroundColor,
    this.iconColor,
    required this.checked,
    required this.onChanged,
    this.onDoubleChanged
  });

  @override
  Widget build(BuildContext context) {
    //LISTA PARA TIPOS DE CAMPOS
    List<IconData>list = [
      AppIcones.foot_futebol_solid,
      AppIcones.foot_fut7_solid,
      AppIcones.foot_futsal_solid,
    ];
    //LISTA PARA TIPOS DE LADO
    List<IconData>side = [
      Icons.back_hand_rounded,
    ];
    //COR DO COMPONENTE DESATIVADO
    final defaultColor = Get.isDarkMode ? AppColors.dark_300 : AppColors.grey_300;

    return Column(
      children: [
        InkWell(
          onDoubleTap: () {
            if(onDoubleChanged != null){
              onDoubleChanged!(value);
            }
          },
          onTap: () => onChanged(value),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: checked ? (backgroundColor ?? Theme.of(context).primaryColor) : defaultColor,
              borderRadius: BorderRadius.circular(80),
              boxShadow: [
                if (checked == true )
                  BoxShadow(
                    color: backgroundColor?.withAlpha(100) ?? Theme.of(context).primaryColor.withAlpha(100),
                    spreadRadius: 8,
                    blurRadius: 1,
                    offset: const Offset(0,0),
                  ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(list.contains(icon))...[
                  Transform.rotate(
                    angle: - 45 * 3.14159 / 200,
                    child: Icon(
                      icon,
                      color: checked ? iconColor : AppColors.white,
                      size: iconSize,
                    ),
                  ) 
                ]else if(side.contains(icon) && value == "Left")...[
                  Transform.flip(
                    flipX: true,
                    child: Icon(
                      icon,
                      color: checked ? iconColor : AppColors.white,
                      size: iconSize,
                    ),
                  ) 
                ]else...[
                  Icon(
                    icon,
                    size: iconSize,
                    color: checked ? iconColor : AppColors.white,
                  ),
                ]
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            label ?? value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: checked ? backgroundColor ?? iconColor : null
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}