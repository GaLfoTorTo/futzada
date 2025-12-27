import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class ButtonIconWidget extends StatelessWidget {
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;
  final double? padding;
  final bool? disabled;
  final double? borderRadius;
  final bool? shadow;
  final VoidCallback action;

  const ButtonIconWidget({
    super.key,
    required this.icon,
    this.iconColor = AppColors.white, 
    this.iconSize = 20, 
    this.backgroundColor = AppColors.green_300,  
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