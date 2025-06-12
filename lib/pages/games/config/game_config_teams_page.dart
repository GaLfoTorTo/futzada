import 'dart:math';
import 'package:futzada/widget/images/img_circle_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/dialogs/emblemas_dialog.dart';
import 'package:futzada/widget/dialogs/game_players_dialog.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class GameConfigTeamsPage extends StatefulWidget {
  final GameModel game;
  const GameConfigTeamsPage({
    super.key,
    required this.game
  });

  @override
  State<GameConfigTeamsPage> createState() => _GameConfigTeamsPageState();
}

class _GameConfigTeamsPageState extends State<GameConfigTeamsPage> {
  //RESHATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //DEFINIR EVENTO DA PARTIDA
  late EventModel event;
  //DEFINIR PARTICIPANTS DA PELADA
  List<MultiSelectItem<dynamic>> participants = [];
  //List<ParticipantModel> _selectedAnimals = [];
  /* List<ParticipantModel> */var teamA = [];
  /* List<ParticipantModel> */var teamB = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  //DEFINIR EMBLEMAS DE EQUIPES
  static List<MultiSelectItem<dynamic>> emblems = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //RESGATAR EVENTO 
    event = gameController.event!;
    //RESGATAR PARTICIPANTES JOGADORES DO EVENTO
    participants = getParticipantsPlayers();
  }

  List<MultiSelectItem<ParticipantModel>> getParticipantsPlayers(){
    //DEFINIR ARRAY DE PARTICIPANTS
    List<MultiSelectItem<ParticipantModel>> arr = [];
    //VERIFICAR SE EVENTO TEM PARTICIPANTS
    if(event.participants != null && event.participants!.isNotEmpty){
      //LOOP NOS PARTICIPANTS DO EVENTO
      event.participants!.map((participant){
        if(participant.user.player != null){
          arr.add(MultiSelectItem<ParticipantModel>(participant, "${participant.user.firstName!} ${participant.user.lastName!}"));
        }
      });
    }
    //RETORNAR PARTICIPANTS FILTRADOS
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //GERAR NUMERO ALEATORIO PARA INDEX DE EMBLEMAS
    int indexA = Random().nextInt(8);
    int indexB = Random().nextInt(8);
    //GERAR INDEX ALEATORIO PARA EMBLEMA DE EQUIPES
    String emblemaIndexA = "emblema_${indexA == 0 ? 1 : indexA}";
    String emblemaIndexB = "emblema_${indexB == 0 ? 1 : indexB}";
    final TextEditingController teamAController = TextEditingController(text: "Team A");
    final TextEditingController teamBController = TextEditingController(text: "Team B");
    
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Definir Equipes',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.green_300
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: dimensions.width * 0.37,
                  child: Column(
                    children: [
                      InputTextWidget(
                        name: 'teamAName',
                        label: 'Time A',
                        textController: teamAController,
                        controller: gameController,
                      ),
                    ],
                  )
                ),
                SizedBox(
                  width: dimensions.width * 0.37,
                  child: Column(
                    children: [
                      InputTextWidget(
                        name: 'teamBName',
                        label: 'Time B',
                        textController: teamBController,
                        controller: gameController,
                      ),
                    ],
                  )
                ),
              ],
            ),
            Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(15),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Get.bottomSheet(
                      EmblemasDialog(
                        emblema: emblemaIndexA
                      ), 
                      isScrollControlled: true
                    ),
                    child: Container(
                      width: dimensions.width * 0.37,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                        width: 100,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray_300, 
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.dark_500,
                      size: 50,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.bottomSheet(
                      EmblemasDialog(
                        emblema: emblemaIndexA
                      ), 
                      isScrollControlled: true
                    ),
                    child: Container(
                      width: dimensions.width * 0.37,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
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
                        AppIcones.emblemas[emblemaIndexB]!,
                        width: 100,
                        colorFilter: const ColorFilter.mode(
                          AppColors.gray_300, 
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Elencos",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: [ 
                  BoxShadow(
                    color: AppColors.dark_500.withAlpha(30),
                    spreadRadius: 0.5,
                    blurRadius: 5,
                    offset: const Offset(2, 5),
                  ),
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: List.generate(gameController.event!.gameConfig!.playersPerTeam!, (item){
                      return InkWell(
                        onTap: () => Get.bottomSheet(
                          GamePlayersDialog(),
                          isScrollControlled: true
                        ),
                        child: Container(
                          width: dimensions.width * 0.45,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1, color: AppColors.gray_300)
                            )
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              ImgCircularWidget(
                                width: 50, 
                                height: 50,
                                borderColor: AppColors.blue_300,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      "Text",
                                      style: Theme.of(context).textTheme.titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "@Text",
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: AppColors.gray_300
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ),
                        ),
                      );
                    })
                  ),
                  Column(
                    children: List.generate(gameController.event!.gameConfig!.playersPerTeam!, (item){
                      return InkWell(
                        onTap: () => Get.bottomSheet(
                          GamePlayersDialog(),
                          isScrollControlled: true
                        ),
                        child: Container(
                          width: dimensions.width * 0.45,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 1, color: AppColors.gray_300)
                            )
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      "Text",
                                      style: Theme.of(context).textTheme.titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "@Text",
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                        color: AppColors.gray_300
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ImgCircularWidget(
                                width: 50, 
                                height: 50,
                                borderColor: AppColors.red_300
                              ),
                            ]
                          ),
                        ),
                      );
                    })
                  ),
                ],
              )
            )
          ]
        ),
    );
  }
}