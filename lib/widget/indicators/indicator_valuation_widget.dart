import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';

class IndicatorValuationWidget extends StatelessWidget {
  final double? points;
  final double? textWidth;
  final String? aligment;
  const IndicatorValuationWidget({
    super.key,
    this.points = 0.0,
    this.textWidth = 10,
    this.aligment = 'start'
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: aligment == 'start' ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            "$points",
            style: TextStyle(
              fontSize: textWidth,
              fontWeight: FontWeight.w500,
              color: AppHelper.setColorPontuation(points)['color'],
            ),
          ),
          Icon(
            AppHelper.setColorPontuation(points)['icon'],
            size: textWidth,
            color: AppHelper.setColorPontuation(points)['color'],
          ),
        ],
      ),
    );
  }
}