import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback action;

  const HeaderWidget({
    super.key, 
    required this.title, 
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.green_300,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          color: AppColors.blue_500,
          fontWeight: FontWeight.normal
        ),
      ),
      leading: BackButton(
        onPressed: action,
      ),
      elevation: 8,
      shadowColor: const Color.fromARGB(255, 0, 0, 0),
    );
  }
}