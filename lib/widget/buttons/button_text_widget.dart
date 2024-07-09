import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class ButtonTextWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final String? icon;
  final String? type;
  final double? width;
  final double? height;
  final VoidCallback action;
  final bool? disabled;
  
  const ButtonTextWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.color,
    this.icon,
    this.type = "normal",
    this.width = double.infinity,
    this.height = 60,
    required this.action,
    this.disabled
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 1, color: color),
          ),
          backgroundColor: type != "outline" ? color : AppColors.white,
        ),
        onPressed: action,
        child: SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(icon != null)
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(
                    icon!,
                    width: 20,
                    height: 20,
                    color: type != "outline" ? textColor : color,
                  ),
                ),
              Text(
                text,
                style: TextStyle(
                  color: type != "outline" ? textColor : color,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}