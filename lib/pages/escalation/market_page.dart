import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/cards/card_player_market_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instace;
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Mercado',
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: dimensions.width,
                height: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark_500.withAlpha(30),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: Offset(2, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Obx(() {
                  return Column(
                    children: controller.playersMarket.map((entry) {
                      //RESGATAR ITENS 
                      Map<String, dynamic> item = entry;
                      return  CardPlayerMarketWidget(
                        player: item,
                        escalation: controller.userEscalation['starters']
                      );
                    }).toList(),
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}