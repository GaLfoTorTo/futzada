import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
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
    this.home = false,
    this.photo,
    this.bottom
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
              backgroundImage: photo != null
                ? CachedNetworkImageProvider(photo!) 
                : const AssetImage(AppImages.userDefault) as ImageProvider,
            )
            : Icon(rightIcon),
            onPressed: rightAction!,
          )
        ]
      ], 
      elevation: 8,
      shadowColor: shadow ? AppColors.dark_500.withAlpha(100) : null,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}