import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final VoidCallback? leftAction;
  final IconData? leftIcon;
  final VoidCallback? rightAction;
  final IconData? rightIcon;
  final VoidCallback? extraAction;
  final IconData? extraIcon;
  final bool shadow;
  final PreferredSizeWidget? bottom;

  const HeaderWidget({
    super.key, 
    this.title, 
    this.leftAction, 
    this.leftIcon = Icons.arrow_back_rounded, 
    this.rightAction, 
    this.rightIcon = Icons.close,
    this.extraAction, 
    this.extraIcon = Icons.history,
    this.shadow = true,
    this.bottom
  });

  @override
  Widget build(BuildContext context) {
    //DEFINIR SOMBRA DO HEADER
    var shadowHeader = shadow ? AppColors.dark_500.withAlpha(100) : null;

    return AppBar(
      backgroundColor: AppColors.green_300,
      title: title != null 
        ? Text(
          title!,
          style: const TextStyle(
            fontSize: 20,
            color: AppColors.blue_500,
            fontWeight: FontWeight.normal
          ),
        )
        : null ,
      leading: IconButton(
        icon: Icon(leftIcon),
        onPressed: leftAction
      ),
      actions: [
          if(extraAction != null)...[
            IconButton(
              icon: Icon(extraIcon),
              onPressed: extraAction!,
            )
          ],
          if(rightAction != null)...[
            IconButton(
              icon: Icon(rightIcon),
              onPressed: rightAction!,
            )
          ]
        ], 
      elevation: 8,
      shadowColor: shadowHeader,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}