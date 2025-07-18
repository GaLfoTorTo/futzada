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
    //DEFINIR PADDING APARTIR DE TAMANHO DO BOTÃO
    final effectiveWidth = width ?? 40;
    final padding = effectiveWidth * 0.03;
    
    return TextButton(
      onPressed: () {
        //VERIFICAR SE BOTÃO FOI DESABILITADO
        if(disabled == false){
          action();
        }
      },
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
                padding: EdgeInsets.only(right: padding),
                child: Icon(icon!, size: iconSize),
              ),
            ],
            if(text != null)...[
              Text(text!),
            ],
            if(iconAfter && icon != null)...[
              Padding(
                padding: EdgeInsets.only(left: padding),
                child: Icon(icon!, size: iconSize),
              ),
            ],
          ],
        )
      ),
    );
  }
}