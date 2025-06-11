import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';

class GameStatisticsPage extends StatefulWidget {
  const GameStatisticsPage({super.key});

  @override
  State<GameStatisticsPage> createState() => _GameStatisticsPageState();
}

class _GameStatisticsPageState extends State<GameStatisticsPage> {
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: dimensions.width,
              height: 500,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.dark_500.withAlpha(30),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: Offset(2, 5),
                  ),
                ],
              ),
              child: Column(
                children: []
              )
            )
          ]
        )
      );
  }
}