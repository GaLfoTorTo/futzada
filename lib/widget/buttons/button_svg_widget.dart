import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class ButtonSvgWidget extends StatelessWidget {
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final double? padding;
  final bool? disabled;
  final VoidCallback action;

  const ButtonSvgWidget({
    super.key,
    required this.icon,
    this.iconColor, 
    this.iconSize, 
    this.backgroundColor = AppColors.white, 
    this.width = 55, 
    this.height = 55, 
    this.padding = 10, 
    this.disabled = false, 
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: disabled! ? null : action,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding ?? 10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          icon!,
          width: iconSize ?? double.infinity,
          height: iconSize ?? double.infinity,
          color: iconColor,
        )
      ),
    );
  }
}