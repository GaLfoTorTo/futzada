import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ButtonCircularWidget extends StatelessWidget {
  final dynamic? icon;
  final Color? iconColor;
  final double? iconWidth;
  final Color? color;
  final double dimensions;
  final VoidCallback action;

  const ButtonCircularWidget({
    super.key,
    required this.icon,
    this.iconColor, 
    this.iconWidth, 
    this.color = Colors.white, 
    required this.dimensions, 
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: dimensions,
        height: dimensions,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(dimensions),
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
            Icon(
              icon!,
              color: iconColor,
            ),
        ),
      ),
    );
  }
}