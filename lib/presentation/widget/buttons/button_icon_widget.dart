import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class ButtonIconWidget extends StatelessWidget {
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final double? padding;
  final bool? disabled;
  final bool? shadow;
  final VoidCallback action;

  const ButtonIconWidget({
    super.key,
    required this.icon,
    this.iconColor = AppColors.white, 
    this.iconSize = 20, 
    this.backgroundColor = AppColors.green_300,  
    this.borderColor,
    this.padding = 10, 
    this.borderRadius = 10,
    this.shadow = false,
    this.disabled = false, 
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {

    return IconButton(
      padding: EdgeInsets.all(padding ?? 0),
      onPressed: () {
        //VERIFICAR SE BOTÃO FOI DESABILITADO
        if(disabled == false){
          action();
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? backgroundColor,
        foregroundColor: iconColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor ?? Colors.transparent),
          borderRadius: BorderRadius.circular(borderRadius ?? 10),
        ),
        textStyle: TextStyle(
          fontSize: iconSize,
        ),
        elevation: shadow == true ? 5 : 0,
        shadowColor: shadow == true ?AppColors.dark_300.withAlpha(50) : null,
      ),
      icon: Icon(
        icon!,
        size: iconSize,
        color: iconColor,
      )
    );
  }
}