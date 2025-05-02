import 'package:flutter/material.dart';

class ButtonTextWidget extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final double? textSize;
  final dynamic icon;
  final double? iconSize;
  final bool iconAfter;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final bool? disabled;
  final VoidCallback action;
  
  const ButtonTextWidget({
    super.key,
    this.text,
    this.textColor,
    this.textSize,
    this.icon,
    this.iconSize,
    this.iconAfter = false,
    this.backgroundColor,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(iconAfter)...[
                if(text != null)...[
                  Text(text!),
                ],
                if(icon != null)...[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(icon!, size: iconSize),
                  ),
                ],
            ]else...[
                if(icon != null)...[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Icon(icon!, size: iconSize),
                  ),
                ],
                if(text != null)...[
                  Text(text!),
                ],
            ],
          ],
        )
      ),
    );
  }
}