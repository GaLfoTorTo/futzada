import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class IndicatorLiveWidget extends StatelessWidget {
  final double? size; 
  final Color? color; 

  const IndicatorLiveWidget({
    super.key,
    this.size = 15,
    this.color = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ao Vivo',
          style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: color,
            fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(
          width: size! + 5,
          child: Stack(
            children: [
              Transform.rotate(
                angle: - math.pi / 2,
                child: Icon(
                  Icons.wifi,
                  color: color,
                  size: size,
                ),
              ),
              Positioned(
                left: 7,
                child: Transform.rotate(
                  angle: math.pi / 2,
                  child: Icon(
                    Icons.wifi,
                    color: color,
                    size: size,
                  ),
                ),
              ),
            ]
          ),
        ),
      ],
    );
  }
}