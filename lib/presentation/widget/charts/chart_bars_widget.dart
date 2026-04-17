import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartBarsWidget extends StatelessWidget {
  final List<double> values;
  final double? width;
  final double? height;
  final Color? color;

  const ChartBarsWidget({
    super.key,
    required this.values,
    this.width = 250,
    this.height = 300,
    this.color = AppColors.green_300
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR DATA DE HOJE COMPLETA
    final today = DateTime.now().weekday;

    return Card(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Atividade Semanal',
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  minY: 0,
                  alignment: BarChartAlignment.spaceBetween,
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
                          return Text(
                            titles[value.toInt()],
                            style: Theme.of(context).textTheme.labelMedium
                          );
                        },
                      ),
                    ),
                  ),
                  barGroups: values.asMap().entries.map((item){
                    double value = item.value.toDouble();
                    int i = item.key;
              
                    return BarChartGroupData(
                      x: i,
                      barsSpace: 20.0,
                      barRods: [
                        BarChartRodData(
                          toY: value,
                          width: 15,
                          borderRadius: BorderRadius.circular(10),
                          color: i == today ? AppColors.green_300 : Theme.of(context).iconTheme.color!.withAlpha(100),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 20,
                            color: AppColors.grey_300.withAlpha(50),
                          ),
                        ),
                      ],
                    );
                  }).toList()
                ),
              ),
            ),
          ],
        ),
      ),
    ); 
  }
}