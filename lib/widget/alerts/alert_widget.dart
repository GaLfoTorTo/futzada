import 'package:flutter/material.dart';
import '/theme/app_colors.dart';

class AlertMessageWidget {
  static SnackBar createSnackBar({
    required String message,
    required String type,
  }) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: AppColors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: type == 'Success' ? AppColors.green_300 : AppColors.red_300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
    );
  }
}
