import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final VoidCallback? leftAction;
  final IconData? leftIcon;
  final VoidCallback? rightAction;
  final IconData? rightIcon;

  const HeaderWidget({
    super.key, 
    this.title, 
    this.leftAction, 
    this.leftIcon = Icons.arrow_back, 
    this.rightAction, 
    this.rightIcon = Icons.close,
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
      shadowColor: title != null ? AppColors.dark_500.withOpacity(0.5) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}