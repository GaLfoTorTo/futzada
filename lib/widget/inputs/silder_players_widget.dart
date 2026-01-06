import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';

class SilderPlayersWidget extends StatelessWidget {
  final Function onChange;
  final double qtdPlayers;
  final double minPlayers;
  final double maxPlayers;
  final int divisions;
  
  const SilderPlayersWidget({
    super.key,
    required this.onChange,
    this.qtdPlayers = 11,
    this.minPlayers = 8,
    this.maxPlayers = 11,
    this.divisions = 3,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? AppColors.dark_300 : AppColors.white,
        borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Nº de Jogadores (Por time)",
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Slider(
            value: qtdPlayers,
            min: minPlayers,
            max: maxPlayers,
            divisions: divisions,
            label: qtdPlayers.toInt().toString(),
            activeColor: AppColors.green_300,
            inactiveColor: AppColors.white,
            onChanged: (double newValue) => onChange(newValue),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              "${qtdPlayers.toInt()}",
              style: Theme.of(context).textTheme.headlineSmall,
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(qtdPlayers.toInt(), (i){
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                child: ImgCircularWidget(
                  width: 30, 
                  height: 30
                ),
              );
            }).toList()
          )    
        ],
      )
    );
  }
}