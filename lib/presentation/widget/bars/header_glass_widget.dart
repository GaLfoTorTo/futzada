import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';

class HeaderGlassWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final VoidCallback? leftAction;
  final IconData? leftIcon;
  final VoidCallback? rightAction;
  final IconData? rightIcon;
  final bool brightness;

  const HeaderGlassWidget({
    super.key, 
    this.title, 
    this.leftAction, 
    this.leftIcon = Icons.arrow_back_rounded, 
    this.rightAction, 
    this.rightIcon = Icons.close,
    this.brightness = false
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: Colors.transparent,
      title: title != null 
        ? Text(
          title!,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: brightness ?AppColors.blue_500 : AppColors.white,
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
              color: brightness ?AppColors.blue_500 : AppColors.white,
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