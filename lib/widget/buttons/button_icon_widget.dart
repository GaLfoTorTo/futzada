import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonIconWidget extends StatelessWidget {
  final String? icon;
  final Color? iconColor;
  final double? iconWidth;
  final Color? color;
  final double? dimensions;
  final VoidCallback action;

  const ButtonIconWidget({
    super.key,
    required this.icon,
    this.iconColor, 
    this.iconWidth,
    this.color = Colors.white, 
    this.dimensions, 
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Container(
        width: dimensions,
        height: dimensions,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(dimensions != 60 ? dimensions! : 10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: icon == "assets/icones/chuteiras/campo.svg" ?
            Transform.rotate(
              angle: - 45 * 3.14159 / 180,
              child: SvgPicture.asset(
                icon!,
                width: double.infinity,
                height: double.infinity,
                color: iconColor,
              ) 
            ) 
          :
            SvgPicture.asset(
              icon!,
              width: double.infinity,
              height: double.infinity,
              color: iconColor,
            ),
        ),
      ),
    );
  }
}