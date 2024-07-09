import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_images.dart';

class LoginBg extends StatelessWidget {
  const LoginBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppImages.gramado,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            color: AppColors.green_300.withOpacity(0.8),
            width: double.infinity,
            height: double.infinity,
          ),
        ],
      ),
    );
  }
}