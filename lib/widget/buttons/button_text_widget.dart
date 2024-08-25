import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';

class ButtonTextWidget extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? color;
  final dynamic? icon;
  final String? type;
  final double? width;
  final double? height;
  final bool? disabled;
  final VoidCallback action;
  
  const ButtonTextWidget({
    super.key,
    required this.text,
    this.textColor = AppColors.blue_500,
    this.color = AppColors.green_300,
    this.icon,
    this.type = "normal",
    this.width = 40,
    this.height = 40,
    this.disabled = false,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR COR DO BOTÃO
    Color currentColor = disabled == true 
      ? AppHelper.brightnessColor(color!)
      : ( type == 'outline' 
        ? AppColors.white 
        : color!
      );
    //RESGATAR COR DE TEXTO DO BOTÃO
    Color currentTextColor = disabled == true 
      ? AppHelper.brightnessColor(AppColors.blue_500)
      : ( type == 'outline' 
        ? AppColors.blue_500 
        : textColor!
      );

    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(10),
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1, 
            color: type == 'outline' 
              ? currentTextColor 
              : Colors.transparent
          ),
        ),
        backgroundColor: currentColor,
        enableFeedback: true,
        foregroundColor: AppColors.gray_500
      ),
      onPressed: action,
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(icon != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  icon!,
                  color: currentTextColor,
                ),
              ),
            Text(
              text,
              style: TextStyle(
                color: currentTextColor,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}