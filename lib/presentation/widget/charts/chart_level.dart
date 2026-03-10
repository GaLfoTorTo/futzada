import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartLevel extends StatelessWidget {
  final int level;
  final double value;
  final Color color;

  const ChartLevel({
    super.key,
    this.level = 0,
    this.value = 0.0,
    this.color = AppColors.white
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: value, 
                color: color,
                radius: 12,
                showTitle: false
              ),
              PieChartSectionData(
                value: 100 - value, 
                color: AppColors.white.withAlpha(50),
                radius: 12,
                showTitle: false
              )
            ]
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'lvl',
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: color
              ),
            ),
            Text(
              level.toString(),
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: color
              ),
            )
          ],
        )
      ]
    );
  }
}