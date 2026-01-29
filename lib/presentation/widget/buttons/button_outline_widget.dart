import 'package:flutter/material.dart';

class ButtonOutlineWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final double? textSize;
  final Color? backgroundColor;
  final dynamic icon;
  final double? iconSize;
  final bool iconAfter;
  final double? width;
  final double? height;
  final bool? disabled;
  final VoidCallback action;
  
  const ButtonOutlineWidget({
    super.key,
    this.text,
    this.textColor,
    this.textSize,
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
    return OutlinedButton(
      onPressed: action,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor ?? backgroundColor,
        foregroundColor: textColor ?? textColor,
        textStyle: TextStyle(
          fontSize: textSize ?? textSize,
        ),
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(!iconAfter && icon != null)...[
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(icon!, size: iconSize),
                ),
            ],
            if(text != null)...[
              Text(text!),
            ],
            if(iconAfter && icon != null)...[
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(icon!, size: iconSize),
              ),
            ],
          ],
        )
      ),
    );
  }
}