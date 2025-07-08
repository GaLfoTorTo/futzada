import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:futzada/theme/app_animations.dart';

class FormOverlayWidget extends StatelessWidget {
  final int status;
  const FormOverlayWidget({
    super.key, 
    required this.status
  });

  @override
  Widget build(BuildContext context) {
    switch(status) {
      case 200:
        return _buildAnimation(AppAnimations.eventSuccess);
      case 400:
        return _buildAnimation(AppAnimations.eventError);
      default:
        return _buildAnimation(AppAnimations.loading);
    }
  }

  Widget _buildAnimation(String asset) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(100),
      child: Center(
        child: Lottie.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}