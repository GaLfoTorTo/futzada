import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:futzada/core/theme/app_animations.dart';
import 'package:futzada/presentation/widget/indicators/indicator_loading_widget.dart';

class FormOverlayWidget extends StatelessWidget {
  final int status;
  final String form;
  const FormOverlayWidget({
    super.key, 
    required this.status,
    required this.form
  });

  @override
  Widget build(BuildContext context) {
    switch(status) {
      case 200:
        return _buildAnimation(form == "event" ? AppAnimations.eventSuccess : AppAnimations.userSuccess);
      case 400:
        return _buildAnimation(form == "event" ? AppAnimations.eventError : AppAnimations.userError);
      default:
        return  const Center(child: IndicatorLoadingWidget());
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