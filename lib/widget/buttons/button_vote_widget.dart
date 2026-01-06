import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

enum Vote {
  Win,
  Draw,
  Lose,
}

class ButtonVoteWidget extends StatelessWidget {
  final String option;
  final double value;
  final double? size;
  final VoidCallback action;

  const ButtonVoteWidget({
    super.key,
    required this.option,
    required this.value,
    this.size,
    required this.action, 
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> setOption(){
      switch (Vote.values.firstWhere((e) => e.name == option)) {
        case Vote.Win:
          return {
            "color" : AppColors.green_300,
            "icon" : Icons.check_circle_rounded
          };
        case Vote.Draw:
          return {
            "color" : AppColors.gray_300,
            "icon" : Icons.remove_circle_rounded
          };
        case Vote.Lose:
          return {
            "color" : AppColors.red_300,
            "icon" : Icons.highlight_remove_rounded
          };
      }
    }
    Color color = setOption()["color"];
    IconData icon = setOption()["icon"];
    return InkWell(
      onTap: action,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: size ?? 100,
        height: size ?? 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size ?? 100),
        ),
        child: Stack(
          alignment: AlignmentGeometry.center,
          children: [
            PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: value, 
                    color: color,
                    radius: 15,
                    showTitle: false
                  ),
                  PieChartSectionData(
                    value: 100 - value, 
                    color: AppColors.gray_500.withAlpha(20),
                    radius: 15,
                    showTitle: false
                  )
                ]
              ),
            ),
            Icon(
              icon,
              size: 50,
              color: color,
            )
          ]
        )
      ),
    );
  }
}