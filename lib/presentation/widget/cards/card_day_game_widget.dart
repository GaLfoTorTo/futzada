import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';

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
  //ESTADO - ITEMS EVENTO
  late Color eventColor;
  late Color eventTextColor;
  late String eventImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ESTADO - ITEMS EVENTO
    eventColor = ModalityHelper.getEventModalityColor(widget.event.gameConfig?.category ?? widget.event.modality!.name)['color'];
    eventTextColor = ModalityHelper.getEventModalityColor(widget.event.gameConfig?.category ?? widget.event.modality!.name)['textColor'];
    eventImage = ModalityHelper.getEventModalityColor(widget.event.gameConfig?.category ?? widget.event.modality!.name)['image'];
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
        color: eventColor,
        image: DecorationImage(
          image: AssetImage(eventImage) as ImageProvider,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            eventColor.withAlpha(200), 
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