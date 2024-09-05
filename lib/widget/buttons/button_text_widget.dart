import 'package:flutter/material.dart';

class ButtonTextWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final Color? backgroundColor;
  final dynamic icon;
  final double? iconSize;
  final bool iconAfter;
  final double? width;
  final double? height;
  final bool? disabled;
  final VoidCallback action;
  
  const ButtonTextWidget({
    super.key,
    this.text,
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.iconSize,
    this.iconAfter = false,
    this.width = 40,
    this.height = 40,
    this.disabled = false,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: action,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? backgroundColor,
        foregroundColor: textColor ?? textColor,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: text != null
        //CASO EXISTA TEXTO
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: iconAfter
              ? [
                  if (text != null) 
                    Text(text!),
                  if (icon != null) 
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Icon(icon!, size: iconSize),
                    ),
                ]
              : [
                  if (icon != null) 
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(icon!, size: iconSize),
                    ),
                  if (text != null) 
                    Text(text!),
                ],
          )
        //CASO EXISTA APENAS ICONE
        : Icon(icon!, size: iconSize),
      ),
    );
  }
}