import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/helpers/date_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/presentation/widget/cards/card_game_widget.dart';
import 'package:futzada/presentation/widget/cards/card_game_live_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_live_widget.dart';
import 'package:futzada/presentation/widget/skeletons/skeleton_games_widget.dart';
import 'package:futzada/presentation/pages/erros/erro_game_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EventGamesPage extends StatefulWidget {
  const EventGamesPage({
    super.key,
  });

  @override
  State<EventGamesPage> createState() => _EventGamesPageState();
}

class _EventGamesPageState extends State<EventGamesPage> {
  //RESGATAR CONTROLLER DO EVENTO
  EventController eventController = EventController.instance;
  //DEFINIR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //CONTROLLADOR DE DESTAQUES
  late PageController inProgressController;
  //ESTADO - EVENTO
  late EventModel event;
  //ESTADO - ITEMS EVENTO
  late String eventDate;
  late Color eventColor;
  late Color eventTextColor;

  @override
  void initState() {
    super.initState();
    //RESGATAR EVENT
    event = eventController.event;
    //RESGATAR CORES E DATAS DA MODALIDADE DA PARTIDA
    eventColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['color'];
    eventTextColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['textColor'];
    //INICIALIZAR CONTROLLER DE PARTIDAS AO VIVO
    inProgressController = PageController();
    //RESGATAR DATA DO PROXIMO DIA DO EVENTO
    eventDate = DateHelper.getDateLabel(gameController.eventDate!);
    //BINDING DE CARREGAMENTO DA PAGINA
    WidgetsBinding.instance.addPostFrameCallback((_) async{  
      //VERIFICAR SE PARTIDAS JÁ FORAM CARREGADAS
      if(gameController.nextGames.isEmpty && gameController.finishedGames.isEmpty){
        //CARREGAR PARTIDAS DO EVENTO
        gameController.loadGames.value = false;
        gameController.loadGames.value = await gameController.setGamesEvent(event);
        //BUSCAR HISTORICO
        gameController.loadHistoricGames.value = await gameController.getHistoricGames();
      } 
    });
  }


  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          spacing: 10,
          children: [
            Text(
              "Agenda",
              style: Theme.of(context).textTheme.titleMedium
            ),
            Text(
              "Explore a agenda completa das partidas da pelada. A quantidade de partidas e calculada a partir das informações de duração e horários de início e fim da pelada definidos pelo organizador.",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            //PARTIDAS DO DIA DE EVENTO
            Obx((){
              //LISTA DE CARDS DE PARTIDAS
              List<Widget> listGames = [];
              //EXIBIR SKELETON NO CARREGAMENTO DAS PARTIDAS
              if(!gameController.loadGames.value) {
                return const SkeletonGamesWidget();
              }
              //EXIBIR PAGINA DE ERRO DE PARTIDA NÃO ENCONTRADA
              if(!gameController.hasGames.value){
                return ErroGamePage(
                  function: () async {
                    gameController.loadGames.value = await gameController.setGamesEvent(event);
                  } 
                );
              }
              //VERIFICAR SE HOJÉ É UM DIA DE EVENTO
              if(gameController.eventDate != null && gameController.today.isAtSameMomentAs(gameController.eventDate!)){
                //EXIBIR CARD DE PARTIDA AO VIVO 
                if(gameController.inProgressGames.isNotEmpty){
                  //ADICIONAR CARD DE PARTIDAS AO VIVO NA LISTA
                  listGames.addAll([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                      ),
                    ),
                    SizedBox(
                      width: dimensions.width,
                      child: PageView(
                        controller: inProgressController,
                        children: [
                          ...gameController.inProgressGames.take(3).map((game){

                            return CardGameLiveWidget(
                              event: event,
                              game: game!,
                            );
                          })
                        ],
                      )
                    ),
                    if(gameController.inProgressGames.length > 1)...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SmoothPageIndicator(
                          controller: inProgressController,
                          count: gameController.inProgressGames.length < 3 ? gameController.inProgressGames.length : 3,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: AppColors.blue_500,
                            dotColor: AppColors.grey_300,
                            expansionFactor: 2,
                          ),
                        ),
                      ),
                    ]
                  ]);
                }
                //VERIFICAR SE EXISTE PARTIDAS PROGRAMADAS                
                if (gameController.nextGames.isNotEmpty) {
                  //ADICIONAR CARD DE PARTIDAS AO VIVO NA LISTA
                  listGames.addAll([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Próximas partidas  - $eventDate',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      spacing: 20,
                      children: gameController.nextGames.asMap().entries.take(5).map((item){
                        //RESGATAR CHAVE E VALOR DO MAPA
                        var key = item.key;
                        //RESGATAR PARTIDA
                        var game = item.value;

                        return CardGameWidget(
                          width: dimensions.width - 10,
                          event: event,
                          game: game!,
                          gameDate: eventDate,
                          navigate: key < 1 ? true : false,
                          active: key < 1 ? true : false,
                        );
                      }).toList(),
                    ),
                    ButtonTextWidget(
                      text: "Ver Mais ${gameController.nextGames.length}",
                      width: 120,
                      height: 20,
                      textColor: eventColor,
                      backgroundColor: eventColor.withAlpha(20),
                      action: () => {},
                    ),
                  ]);
                }
              }
              if(gameController.scheduledGames.isNotEmpty && gameController.scheduledGames.length < 4){
                //VERIFICAR SE EXISTE PARTIDAS PROGRAMADAS                
                if (gameController.scheduledGames.isEmpty) {
                  return const SizedBox.shrink();
                }
                //RESGATAR DATA DO PROXIMO DIA DO EVENTO
                eventDate = DateHelper.getDateLabel(gameController.scheduledGames.first!.startTime!);
                listGames.addAll([
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Partidas Agendadas - $eventDate',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    spacing: 20,
                    children: [
                      ...gameController.scheduledGames.take(10).map((game){
                        return CardGameWidget(
                          width: dimensions.width - 10,
                          event: event,
                          game: game!,
                          gameDate: eventDate,
                          active: false
                        );
                      })
                    ]
                  ),
                  ButtonTextWidget(
                    text: "Ver Mais ${gameController.scheduledGames.length}",
                    width: 100,
                    height: 20,
                    textColor: AppColors.green_300,
                    backgroundColor: AppColors.green_300.withAlpha(20),
                    action: () => {},
                  ),
                ]);
              }
              return listGames.isNotEmpty 
                ? Column(children: listGames)
                : const SizedBox.shrink();
            }),
          ]
        ),
      ),
    );
  }
}