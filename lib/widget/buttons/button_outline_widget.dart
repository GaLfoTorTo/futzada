import 'package:flutter/material.dart';

class ButtonOutlineWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final Color? backgroundColor;
  final dynamic icon;
  final bool iconAfter;
  final double? width;
  final double? height;
  final bool? disabled;
  final VoidCallback action;
  
  const ButtonOutlineWidget({
    super.key,
    this.text,
    this.textColor,
    this.backgroundColor,
    this.icon,
    this.iconAfter = false,
    this.width = 40,
    this.height = 40,
    this.disabled = false,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: action,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? backgroundColor,
        foregroundColor: textColor ?? textColor,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconAfter
            ? [
                if (text != null) Text(text!),
                if (icon != null) Icon(icon!),
              ]
            : [
                if (icon != null) Icon(icon!),
                if (text != null) Text(text!),
              ],
        ),
      ),
    );
  }
}