import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String? title;
  final String? iconLeft;
  final String? iconRight;
  final VoidCallback? actionLeft;
  final VoidCallback? actionRight;

  const HeaderWidget({
    super.key, 
    this.title = "", 
    this.iconLeft = "", 
    this.iconRight = "", 
    required this.actionLeft,
    this.actionRight
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.green_300,
      title: Text(
        title!,
        style: const TextStyle(
          color: AppColors.blue_500,
          fontWeight: FontWeight.normal
        ),
      ),
      leading: iconLeft == null
      ? 
        BackButton(
            color: AppColors.blue_500,
        )
      :
        InkWell(
          onTap: actionLeft,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: SvgPicture.asset(
                iconLeft!,
                width: double.maxFinite,
                height: double.maxFinite,
                color: AppColors.blue_500,
              ),
            ),
          ),
        ),
      actions: [
        if(iconRight != "")
          InkWell(
            onTap: actionRight,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: SvgPicture.asset(
                  iconRight!,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  color: AppColors.blue_500,
                ),
              ),
            ),
          ),
      ],
      elevation: 8,
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}