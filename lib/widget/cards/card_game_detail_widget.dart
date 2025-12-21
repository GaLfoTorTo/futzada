import 'package:futzada/models/game_event_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/enum/enums.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/animated/animated_ellipsis.dart';
import 'package:futzada/widget/images/img_group_circle_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';

class CardGameDetailWidget extends StatefulWidget {
  final EventModel event;
  final GameModel game;
  
  const CardGameDetailWidget({
    super.key,
    required this.event,
    required this.game,
  });

  @override
  State<CardGameDetailWidget> createState() => _CardGameDetailWidgetState();
}

class _CardGameDetailWidgetState extends State<CardGameDetailWidget> {
  //RESGATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //CONTROLADOR DE TIMES DEFINIDO
  bool teamDefined = false;
  //LISTA DE IMAGENS DOS JOGADORES
  List<String?>teamAplayersImg = [];
  List<String?>teamBplayersImg = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    teamAplayersImg = gameController.currentGame.teams!.first.players.take(3).map((item){
      return item.user.photo;
    }).toList();
    teamBplayersImg = gameController.currentGame.teams!.first.players.take(3).map((item){
      return item.user.photo;
    }).toList();
  }

  //FUNÇÃO DE AGRUPAMENTO DE EVENTOS DE GOL DO JOGADOR
  Map<int, List<int>> groupGoalsByPlayer(List<GameEventModel> events) {
    //
    final Map<int, List<int>> grouped = {};

    for (final event in events) {
      final user = event.participant?.user;
      if (user == null) continue;
      //ADICIONAR JOGADOR
      grouped.putIfAbsent(user.id!, () => []);
      grouped[user.id]?.add(event.minute ?? 0);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Container(
      width: dimensions.width,
      margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
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
      child: Column(
        spacing: 10,
        children: [
          //NOME EVENTO
          Text(
            "${widget.event.title}",
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
              color: AppColors.gray_500,
            ),
          ),
          //PLACAR
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: const AssetImage(AppImages.gramado) as ImageProvider,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  AppColors.green_300.withAlpha(150), 
                  BlendMode.srcATop,
                )
              ),
            ),
            child: Row(
              children: [
                //TIME A
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        gameController.currentGame.teams!.first.name!,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.blue_500
                        )
                      ),
                      SvgPicture.asset(
                        AppIcones.emblemas[gameController.currentGame.teams!.first.emblema!]!,
                        width: 100,
                        height: 100,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white, 
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        'Home',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.blue_500
                        )
                      ),
                    ],
                  ),
                ),
                //CRONOMETRO E PLACAR
                Obx(() {
                  final teamAScore = gameController.teamAScore.value;
                  final teamBScore = gameController.teamBScore.value;

                  //RESGATAR TEMPO DA PARTIDA
                  final currentTime = gameController.currentTime.value;
                  final parts = currentTime.split(':');
                  final minutes = int.tryParse(parts[0]) ?? 0;
                  //VERIFICAR SE TEMPO ULTRAPAÇOU LIMITE DA PARTIDA
                  final isExtraTime = minutes > (widget.game.duration ?? 0);
                  //PLACAR
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //INDICADOR DE AO VIVO
                      if (gameController.currentGame.status == GameStatus.In_progress)...[
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.red_300,
                          ),
                          child: const IndicatorLiveWidget(
                            size: 15,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                      //PLACAR
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          children: [
                            Text(
                              "$teamAScore",
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: AppColors.white,
                                fontSize: 60
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'X', 
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: AppColors.blue_500
                                )
                              ),
                            ),
                            Text(
                              "$teamBScore",
                              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                color: AppColors.white,
                                fontSize: 60
                              )
                            ),
                          ],
                        ),
                      ),
                      //TEMPORIZADOR
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: AppColors.dark_300,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Text(
                              currentTime,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DS-DIGITAL',
                                color: isExtraTime ? AppColors.red_300 : AppColors.green_300,
                              ),
                            ),
                          ),
                          
                          if(isExtraTime) ...[
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Tempo Extra",
                                style: TextStyle(
                                  color: AppColors.red_300,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  );
                }),
                //TEAM B
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        gameController.currentGame.teams!.last.name!,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: AppColors.blue_500
                        )
                      ),
                      SvgPicture.asset(
                        AppIcones.emblemas[gameController.currentGame.teams!.last.emblema!]!,
                        width: 100,
                        height: 100,
                        colorFilter: const ColorFilter.mode(
                          AppColors.white, 
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        'Away',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.blue_500
                        )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //REGISTRADOR DE EVENTOS DA PARTIDA
          Obx((){
            final game = gameController.currentGame;
            final temAGameEvents = gameController.gameEvents.where((t) => t.team.id == game.teams!.first.id).toList();
            final temBGameEvents = gameController.gameEvents.where((t) => t.team.id == game.teams!.last.id).toList();
            return  Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(2, (i){
                //RESGATAR EVENTOS PRA CADA TIME
                final teamGameEvents = i == 0 ? temAGameEvents : temBGameEvents;
                if(teamGameEvents.isEmpty) return Container();
                //AGRUPAR GOLS POR JOGADOR
                final groupedGoals = groupGoalsByPlayer(teamGameEvents.where((e) => e.type?.name == 'Goal').toList());

                return SizedBox(
                  width: dimensions.width * 0.37,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 5,
                    children: groupedGoals.entries.map((entry) {
                      final playerId = entry.key;
                      final minutes = entry.value..sort();
                  
                      final event = teamGameEvents.firstWhere(
                        (e) => e.participant?.user.id == playerId,
                      );
                  
                      final user = event.participant!.user;
                      return Row(
                        spacing: 5,
                        children: [
                          if(i == 0)...[
                            const Icon(
                              AppIcones.futebol_ball_solid,
                              size: 12,
                              color: AppColors.gray_500,
                            ),
                            Text(
                              "${user.firstName} ${user.lastName}",
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: AppColors.gray_500
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "${minutes.map((m) => "$m'").join(', ')}",
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: AppColors.gray_500
                                ),
                                softWrap: true,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                          if(i == 1)...[
                            Flexible(
                              child: Text(
                                "${minutes.map((m) => "$m'").join(', ')}",
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                  color: AppColors.gray_500
                                ),
                                softWrap: true,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Text(
                              "${user.firstName} ${user.lastName}",
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: AppColors.gray_500
                              ),
                            ),
                            const Icon(
                              AppIcones.futebol_ball_solid,
                              size: 12,
                              color: AppColors.gray_500,
                            )
                          ]
                        ],
                      );
                    }).toList(),
                  ),
                );
              })
            );
          }),
        ],
      ),
    );
  }
}