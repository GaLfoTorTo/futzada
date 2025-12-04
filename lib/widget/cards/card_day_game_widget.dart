import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/controllers/game_controller.dart';

class CardDayGameWidget extends StatefulWidget {
  final EventModel event;
  const CardDayGameWidget({
    super.key,
    required this.event,
  });

  @override
  State<CardDayGameWidget> createState() => _CardGameLiveWidgetState();
}

class _CardGameLiveWidgetState extends State<CardDayGameWidget> {
  //DEFINIR COR DO CARD
  late Color cardColor = AppColors.green_300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;

    return Container(
      width: dimensions.width - 10,
      height: 300,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.green_300,
        image: DecorationImage(
          image: const AssetImage(AppImages.gramado) as ImageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            AppColors.green_300.withAlpha(220), 
            BlendMode.srcATop,
          )
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark_500.withAlpha(50),
            spreadRadius: 0.5,
            blurRadius: 5,
            offset: const Offset(2, 5),
          ),
        ],
      ),
    );
  }
}