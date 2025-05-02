import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final VoidCallback? leftAction;
  final IconData? leftIcon;
  final VoidCallback? rightAction;
  final IconData? rightIcon;
  final bool shadow;

  const HeaderWidget({
    super.key, 
    this.title, 
    this.leftAction, 
    this.leftIcon = Icons.arrow_back, 
    this.rightAction, 
    this.rightIcon = Icons.close,
    this.shadow = true,
  });

  @override
  Widget build(BuildContext context) {
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
      actions: rightAction != null
        ? [
            IconButton(
              icon: Icon(rightIcon),
              onPressed: rightAction!,
            )
          ]
        : [], 
      elevation: 8,
      shadowColor: shadow 
        ? AppColors.dark_500.withAlpha(100) 
        : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}