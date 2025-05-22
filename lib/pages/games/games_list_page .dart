import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class GamesListPage extends StatelessWidget {
  const GamesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE CHAT
    var controller = GameController.instace;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Partidas',
        leftAction: () => Get.back(),
        rightIcon: Icons.history,
        rightAction: () => Get.toNamed('/games/historic'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ImgCircularWidget(
                        width: 30, 
                        height: 30,
                        image: null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'Futzada',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      IndicatorLiveWidget(
                        size: 15,
                        color: AppColors.red_300,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: dimensions.width - 10,
                  height: 300,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                    children: [

                    ],
                  ),
                ),
                /* Obx(() {
                  return Column(
                    children: controller.events.map((entry) {
                      //RESGATAR ITENS 
                      Map<String, dynamic> item = entry;
                      return  CardEventListWidget(
                        event: item,
                      );
                    }).toList(),
                  );
                }), */
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Próxima partida',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      ButtonTextWidget(
                        text: "Ver Mais",
                        width: 80,
                        height: 20,
                        textColor: AppColors.green_300,
                        backgroundColor: Colors.transparent,
                        action: () {},
                      ),
                    ],
                  ),
                ),
                Container(
                  width: dimensions.width - 10,
                  height: 150,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
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
                    children: [

                    ],
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}