import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class HeaderGlassWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final VoidCallback? leftAction;
  final IconData? leftIcon;
  final VoidCallback? rightAction;
  final IconData? rightIcon;
  final Color? rightColor;
  final bool brightness;

  const HeaderGlassWidget({
    super.key, 
    this.title, 
    this.leftAction, 
    this.leftIcon = Icons.arrow_back_rounded, 
    this.rightAction, 
    this.rightIcon = Icons.close,
    this.rightColor = AppColors.white,
    this.brightness = false
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: Colors.transparent,
      title: title != null 
        ? Text(
          title!,
          style: TextStyle(
            fontSize: 20,
            color: brightness ?AppColors.blue_500 : AppColors.white,
            fontWeight: FontWeight.normal
          ),
        )
        : null ,
      leading: IconButton(
        icon: Icon(
          leftIcon,
          color: brightness ?AppColors.blue_500 : AppColors.white,
        ),
        onPressed: leftAction
      ),
      actions: [
        if(rightAction != null)...[
          IconButton(
            icon: Icon(
              rightIcon,
              color: rightColor ?? AppColors.white,
            ),
            onPressed: rightAction!,
          )
        ]
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}