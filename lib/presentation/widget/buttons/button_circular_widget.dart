import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_icones.dart';

class ButtonCircularWidget extends StatelessWidget {
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? color;
  final double size;
  final bool? checked;
  final VoidCallback action;

  const ButtonCircularWidget({
    super.key,
    this.icon,
    this.iconColor, 
    this.iconSize, 
    this.checked, 
    this.color = Colors.white, 
    required this.size, 
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size),
          boxShadow: [
            if (checked != null && checked == true )
              BoxShadow(
                color: color!.withAlpha(50),
                spreadRadius: 8,
                blurRadius: 1,
                offset: Offset(0,0),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: icon == AppIcones.foot_futebol_solid ?
            Transform.rotate(
              angle: - 45 * 3.14159 / 200,
              child: Icon(
                icon!,
                color: iconColor,
                size: iconSize,
              ),
            ) 
          :
            Icon(
              icon!,
              color: iconColor,
              size: iconSize,
            ),
        ),
      ),
    );
  }
}