import 'dart:math';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/controllers/game_controller.dart';

class CardGameWidget extends StatefulWidget {
  final double? width;
  final EventModel event;
  final GameModel game;
  final String gameDate;
  final String? route;
  final bool? navigate;
  final bool? active;
  final bool? historic;

  CardGameWidget({
    super.key,
    this.width,
    required this.event,
    required this.game,
    required this.gameDate,
    this.route,
    this.navigate = false,
    this.active = false,
    this.historic = false,
  });

  @override
  State<CardGameWidget> createState() => _CardGameWidgetState();
}

class _CardGameWidgetState extends State<CardGameWidget> {
  //RESGATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //RESGATAR PROPS DE NAVEGAÇÃO E ATIVAÇÃO DO CARD
  bool propNavigate = false;
  bool propActive = false;
  bool propHistoric = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //RESGATAR PROP DE NAVEGAÇÃO PADRÃO
    propNavigate = widget.navigate != null ? widget.navigate! : false;
    //RESGATAR PROP DE ATIVAÇÃO PADRÃO DO CARD
    propActive = widget.active != null ? widget.active! : false;
    //RESGATAR PROP DE HISTÓRICO PADRÃO DO CARD
    propHistoric = widget.historic != null ? widget.historic! : false;
  }

  @override
  Widget build(BuildContext context) {

    //RESGATAR HORARIO DE INICIO E FIM DA PARTIDA
    var gameStartTime = DateFormat.Hm().format(widget.game.startTime!);
    var gameEndTime = DateFormat.Hm().format(widget.game.endTime!);
    //RESGATAR RESULTADO DA PARTIDA
    int teamAScore = widget.game.result != null && widget.game.result!.teamAScore > 0 ? widget.game.result!.teamAScore: 0;
    int teamBScore = widget.game.result != null && widget.game.result!.teamBScore > 0 ? widget.game.result!.teamBScore: 0;
    //GERAR NUMERO ALEATORIO PARA INDEX DE EMBLEMAS
    int indexA = Random().nextInt(8);
    int indexB = Random().nextInt(8);
    //GERAR INDEX ALEATORIO PARA EMBLEMA DE EQUIPES
    String emblemaIndexA = "emblema_${indexA == 0 ? 1 : indexA}";
    String emblemaIndexB = "emblema_${indexB == 0 ? 1 : indexB}";

    return InkWell(
      onTap: (){
        //VERIFICAR SE CLICK ESTA HABILITADO
        if(propNavigate) {
          //DEFINIR PARTIDA ATUAL
          gameController.setCurrentGame(widget.game);
          //VERIFICAR ROTA DE NAVEGAÇÃO
          if(widget.route == 'config'){
            //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
            Get.toNamed('/games/config', arguments: {
              'game': widget.game,
              'event': widget.event,
            });
          }else{
            //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
            Get.toNamed('/games/overview');
          }
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.dark_500.withAlpha(30),
              spreadRadius: 0.5,
              blurRadius: 5,
              offset: const Offset(2, 5),
            ),
          ],
          image: DecorationImage(
            image: const AssetImage(AppImages.gramado) as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.green_300.withAlpha(180),
              BlendMode.srcATop,
            )
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: !propActive ? BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.gray_300,
            backgroundBlendMode: BlendMode.saturation,
          ) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "#${widget.game.number}",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.white
                )
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SvgPicture.asset(
                      AppIcones.emblemas[emblemaIndexA]!,
                      width: 50,
                      height: 50,
                      colorFilter: ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                    Column(
                      spacing: 5,
                      children: [
                        Text(
                          widget.gameDate,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.white,
                            fontSize: !propHistoric ? 18 : 16
                          ),
                        ),
                        if(propHistoric)...[
                          Row(
                            spacing: 20,
                            children: [
                              Text(
                                "$teamAScore",
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: AppColors.white,
                                  fontSize: 42
                                ),
                              ),
                              Text(
                                "X",
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              Text(
                                "$teamBScore",
                                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                  color: AppColors.white,
                                  fontSize: 42
                                ),
                              ),
                            ],
                          )
                        ],
                        Text(
                          "$gameStartTime - $gameEndTime",
                          style: Theme.of(context).textTheme.labelLarge!.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    SvgPicture.asset(
                      AppIcones.emblemas[emblemaIndexB]!,
                      width: 50,
                      height: 50,
                      colorFilter: ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}