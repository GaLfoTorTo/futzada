import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/img_helper.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final Color? backgroundColor;
  final VoidCallback? leftAction;
  final IconData? leftIcon;
  final VoidCallback? rightAction;
  final IconData? rightIcon;
  final VoidCallback? extraAction;
  final IconData? extraIcon;
  final bool shadow;
  final bool? home;
  final String? photo;
  final PreferredSizeWidget? bottom;
  final bool brightness;

  const HeaderWidget({
    super.key, 
    this.title,
    this.backgroundColor,
    this.leftAction, 
    this.leftIcon = Icons.arrow_back_rounded, 
    this.rightAction, 
    this.rightIcon = Icons.close,
    this.extraAction, 
    this.extraIcon = Icons.history,
    this.shadow = true,
    this.home = false,
    this.photo,
    this.bottom,
    this.brightness = false
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: brightness ? Colors.transparent : ( backgroundColor ?? Theme.of(context).primaryColor),
      title: title != null 
        ? Text(
          title!,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: AppColors.blue_500
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
            icon: home != null && home == true
            ? CircleAvatar(
              backgroundImage: ImgHelper.getUserImg(photo),
            )
            : Icon(rightIcon),
            onPressed: rightAction!,
          )
        ]
      ], 
      elevation: 3,
      shadowColor: shadow ? AppColors.dark_500.withAlpha(100) : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}