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
    //RESGATAR CONTROLLER DE PARTIDA
    GameController gameController = GameController.instance;

    //RESGATAR EQUIPES DA PARTIDA
    TeamModel teamA = widget.game.teams!.first;
    TeamModel teamB = widget.game.teams!.last;

    return InkWell(
      onTap: (){
        //DEFINIR PARTIDA ATUAL
        gameController.setCurrentGame(widget.game);
        //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
        Get.toNamed('/games/overview');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
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
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "${widget.event.title}",
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              Text(
                "#${widget.game.number}",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.white,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcones.emblemas[teamA.emblema]!,
                          width: 60,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white, 
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "${teamA.name}",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "$teamAScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 40,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Text(
                    ":",
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontSize: 35,
                      color: AppColors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "$teamBScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        fontSize: 40,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcones.emblemas[teamB.emblema]!,
                          width: 60,
                          colorFilter: const ColorFilter.mode(
                            AppColors.white, 
                            BlendMode.srcIn,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            "${teamB.name}",
                            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
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
                        color: AppColors.white
                      ),
                      Container(
                        height: 20,
                        width: 50,
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.white.withAlpha(100),
                          borderRadius: const BorderRadius.all(Radius.circular(5))
                        ),
                        child: const AnimatedEllipsis(
                          dotSize: 5,
                          dotColor: AppColors.white,
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