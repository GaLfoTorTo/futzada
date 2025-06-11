import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:intl/intl.dart';

class CardGameWidget extends StatelessWidget {
  final double? width;
  final EventModel event;
  final GameModel game;
  final String gameDate;
  final bool? navigate;
  final bool? active;
  final bool? historic;

  const CardGameWidget({
    super.key,
    this.width,
    required this.event,
    required this.game,
    required this.gameDate,
    this.navigate = false,
    this.active = false,
    this.historic = false,
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR PROP DE NAVEGAÇÃO PADRÃO
    var propNavigate = navigate != null ? navigate! : false;
    //RESGATAR PROP DE ATIVAÇÃO PADRÃO DO CARD
    var propActive = active != null ? active! : false;
    //RESGATAR PROP DE HISTÓRICO PADRÃO DO CARD
    var propHistoric = historic != null ? historic! : false;
 
    //RESGATAR HORARIO DE INICIO E FIM DA PARTIDA
    var gameStartTime = DateFormat.Hm().format(game.startTime!);
    var gameEndTime = DateFormat.Hm().format(game.endTime!);
    //RESGATAR RESULTADO DA PARTIDA
    int teamAScore = game.result != null && game.result!.teamAScore > 0 ? game.result!.teamAScore: 0;
    int teamBScore = game.result != null && game.result!.teamBScore > 0 ? game.result!.teamBScore: 0;
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
          //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
          Get.toNamed('/games/game_detail', arguments: {
            'game': game,
            'event': event,
          });
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
          children: [
            Stack(
              children:[ 
                Container(
                  width: width,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius:const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    image: DecorationImage(
                      image: event.photo != null 
                        ? CachedNetworkImageProvider(event.photo!) 
                        : const AssetImage(AppImages.gramado) as ImageProvider,
                      fit: BoxFit.cover,
                      colorFilter: !propActive
                        ? const ColorFilter.mode(
                            AppColors.gray_300, 
                            BlendMode.saturation,
                          )
                        : null
                    ),
                  ),
                ),
                if(!propActive)...[
                  Container(
                    width: width,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                      color: AppColors.gray_300.withAlpha(150),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    "#${game.number}",
                    style: Theme.of(context).textTheme.headlineLarge
                  ),
                ),
              ]
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gameDate,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.gray_500,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.circle, 
                      color: AppColors.gray_300,
                      size: 4,
                    ),
                  ),
                  Text(
                    "${event.address}",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.gray_500,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.circle, 
                      color: AppColors.gray_300,
                      size: 4,
                    ),
                  ),
                  Text(
                    "$gameStartTime as $gameEndTime",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                      color: AppColors.gray_500,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70,
                  height: 70,
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
                    AppIcones.emblemas[emblemaIndexA]!,
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gray_300, 
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if(propHistoric)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "$teamAScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: AppColors.gray_500,
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: propHistoric ? 10 : 30),
                  child: Text(
                    "X",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.gray_300,
                    ),
                  ),
                ),
                if(propHistoric)...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "$teamBScore",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                        color: AppColors.gray_500,
                      ),
                    ),
                  ),
                ],
                Container(
                  width: 70,
                  height: 70,
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
                    AppIcones.emblemas[emblemaIndexB]!,
                    width: 40,
                    height: 40,
                    colorFilter: const ColorFilter.mode(
                      AppColors.gray_300, 
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}