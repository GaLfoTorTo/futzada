import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/models/team_model.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/animated/animated_ellipsis.dart';
import 'package:futzada/widget/others/timer_counter_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futzada/controllers/game_controller.dart';

class CardGameLiveWidget extends StatefulWidget {
  final EventModel event;
  final GameModel game;
  const CardGameLiveWidget({
    super.key,
    required this.event,
    required this.game,
  });

  @override
  State<CardGameLiveWidget> createState() => _CardGameLiveWidgetState();
}

class _CardGameLiveWidgetState extends State<CardGameLiveWidget> {
  //DEFINIR COR DO CARD
  late Color cardColor = AppColors.green_300;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //RESGATAR COR PREDOMINANTE DA FOTO DO EVENTO
    loadColorEvent();
  }
  //LOAD PREDOMINANTE COR DE IMAGEM DO EVENTO
  void loadColorEvent() async {
    //RESGATAR COR DOMINANT NO CACHE
    final dominantColor = await AppColors.getCachedDominantColor(widget.event.photo);
    setState(() {
      cardColor = dominantColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;

    //RESGATAR EQUIPES DA PARTIDA
    TeamModel teamA = widget.game.teams!.first;
    TeamModel teamB = widget.game.teams!.last;

    return InkWell(
      onTap: (){
        //DEFINIR PARTIDA ATUAL
        gameController.currentGame = widget.game;
        //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
        Get.toNamed('/games/overview', arguments: {
          'game': widget.game,
          'event': widget.event,
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: dimensions.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(30),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(2, 5),
            ),
          ],
          image: DecorationImage(
            image: widget.event.photo != null 
              ? CachedNetworkImageProvider(widget.event.photo!) 
              : const AssetImage(AppImages.gramado) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              cardColor.withAlpha(150), 
              BlendMode.srcATop,
            )
          ),
        ),
        child: 
        Obx(() {
          //RESGATAR PLACAR DA PARTIDA
          final teamAScore = gameController.teamAScore.value;
          final teamBScore = gameController.teamBScore.value;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "#${widget.game.number}",
                  style: Theme.of(context).textTheme.headlineLarge
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dark_500.withAlpha(30),
                          spreadRadius: 0.5,
                          blurRadius: 5,
                          offset: const Offset(2, 5),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      AppIcones.emblemas[teamA.emblema]!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.gray_300, 
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.green_100.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$teamAScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: teamAScore > teamBScore? AppColors.green_300 : AppColors.gray_700,
                      ),
                    ),
                  ),
                  Text(
                    "x",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.gray_300,
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.green_100.withAlpha(100),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "$teamBScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: teamBScore > teamAScore? AppColors.green_300 : AppColors.gray_700,
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.white,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.dark_500.withAlpha(30),
                          spreadRadius: 0.7,
                          blurRadius: 5,
                          offset: const Offset(-2, 5),
                        ),
                      ],
                    ),
                    child: SvgPicture.asset(
                      AppIcones.emblemas[teamB.emblema]!,
                      colorFilter: const ColorFilter.mode(
                        AppColors.gray_300, 
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      TimerCounterWidget(
                        game: widget.game,
                      ),
                      Container(
                        height: 20,
                        width: 50,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.green_100.withAlpha(100),
                          borderRadius: BorderRadius.all(Radius.circular(5))
                        ),
                        child: const AnimatedEllipsis(
                          dotSize: 5,
                          dotColor: AppColors.green_500,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          );
        })
      ),
    );
  }
}