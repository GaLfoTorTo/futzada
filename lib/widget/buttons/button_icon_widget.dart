import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class ButtonIconWidget extends StatelessWidget {
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? color;
  final double? width;
  final double? height;
  final bool? disabled;
  final VoidCallback action;

  const ButtonIconWidget({
    super.key,
    required this.icon,
    this.iconColor, 
    this.iconSize, 
    this.color = AppColors.white, 
    this.width = 55, 
    this.height = 55, 
    this.disabled = false, 
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {
    //FUNÇÃO PARA RETORNAR ICONE 
    Widget iconBuilder(){
      if(icon is String){
        return SvgPicture.asset(
          icon!,
          width: iconSize ?? double.infinity,
          height: iconSize ?? double.infinity,
          color: iconColor,
        );
      }else{
        return Icon(
          icon!,
          size: iconSize,
          color: iconColor,
        );
      }
    }

    return InkWell(
      onTap: disabled! ? null : action,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: iconBuilder()
        ),
      ),
    );
  }
}