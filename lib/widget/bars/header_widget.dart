import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget implements PreferredSizeWidget{
  final String? title;
  final VoidCallback action;

  const HeaderWidget({
    super.key, 
    this.title, 
    required this.action, 
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
      leading: BackButton(
        onPressed: action,
      ),
      elevation: 8,
      shadowColor: title != null ? AppColors.dark_500.withOpacity(0.5) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}