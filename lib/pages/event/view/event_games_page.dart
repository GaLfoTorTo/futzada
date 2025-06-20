import 'package:futzada/widget/skeletons/skeleton_games_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/cards/card_game_widget.dart';
import 'package:futzada/widget/cards/card_game_live_widget.dart';
import 'package:futzada/pages/erros/erro_game_page.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EventGamesPage extends StatefulWidget {
  final TabController tabController;
  const EventGamesPage({
    super.key,
    required this.tabController
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
  //ESTADO - DIA ATUAL
  late String eventDate;

  @override
  void initState() {
    super.initState();
    //RESGATAR EVENT
    event = eventController.event;
    //INICIALIZAR CONTROLLER DE PARTIDAS AO VIVO
    inProgressController = PageController();
    //RESGATAR DATA DO PROXIMO DIA DO EVENTO
    eventDate = DateFormat("EEE - dd/MM/y").format(gameController.eventDate!);
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
          children: [
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
                      height: 350,
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
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: SmoothPageIndicator(
                          controller: inProgressController,
                          count: gameController.inProgressGames.length < 3 ? gameController.inProgressGames.length : 3,
                          effect: const ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor: AppColors.blue_500,
                            dotColor: AppColors.gray_300,
                            expansionFactor: 2,
                          ),
                        ),
                      ),
                    ]
                  ]);
                }
                //VERIFICAR SE EXISTE PARTIDAS PROGRAMADAS                
                if (gameController.nextGames.isNotEmpty) {
                  //RESGATAR QUANTIDADE DE PARTIDAS PROGRAMADAS E QUANTIDADE DE ITEMS DE EXIBIÇÃO
                  int qtdGames = gameController.nextGames.length;
                  int qtdView = gameController.qtdView.value;
                  //VERIFICAR SE EVENTO CONTEM CONFIGURAÇÕES DE PARTIDA DEFINIDA
                  bool hasConfigGame= event.gameConfig != null;
                  //ADICIONAR CARD DE PARTIDAS AO VIVO NA LISTA
                  listGames.addAll([
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Próximas partidas',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children:[ 
                        SizedBox(
                          height: (240 * qtdView).toDouble(),
                          child: Column(
                            spacing: 20,
                            children: [
                              ...gameController.nextGames.asMap().entries.take(qtdView).map((item){
                                //RESGATAR CHAVE E VALOR DO MAPA
                                var key = item.key;
                                //RESGATAR PARTIDA
                                var game = item.value;

                                return CardGameWidget(
                                  width: dimensions.width - 10,
                                  event: event,
                                  game: game!,
                                  gameDate: eventDate,
                                  navigate: key < 2 ? true : false,
                                  active: key < 2 ? true : false,
                                  route: hasConfigGame ? 'detail' : 'config',
                                );
                              })
                            ]
                          ),
                        ),
                        //EFEITO DE FADE
                        if(qtdView < qtdGames)...[
                          Positioned(
                            bottom: -10,
                            left: 0,
                            right: 0,
                            height: 250,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.light.withAlpha(20),
                                    AppColors.light,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                      ]
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          if(qtdView < qtdGames)...[
                            ButtonTextWidget(
                              text: "Ver Mais",
                              width: 80,
                              height: 20,
                              textColor: AppColors.blue_500,
                              backgroundColor: AppColors.green_300,
                              action: () => gameController.setView(true, qtdGames),
                            ),
                          ],
                          if(qtdView > 3)...[
                            ButtonTextWidget(
                              text: "Ver Menos",
                              width: 80,
                              height: 20,
                              textColor: AppColors.blue_500,
                              backgroundColor: AppColors.green_300,
                              action: () => gameController.setView(false, qtdGames),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ]);
                }
              }
              return listGames.isNotEmpty 
                  ? Column(children: listGames)
                  : const SizedBox.shrink();
            }),
            //PARTIDAS AGENDADAS
            Obx(() {
              final scheduledGames = gameController.scheduledGames;
              //VERIFICAR SE EXISTE PARTIDAS PROGRAMADAS                
              if (gameController.scheduledGames.isEmpty) {
                return const SizedBox.shrink();
              }
              //RESGATAR QUANTIDADE DE PARTIDAS PROGRAMADAS E QUANTIDADE DE ITEMS DE EXIBIÇÃO
              int qtdGames = scheduledGames.length;
              int qtdView = gameController.qtdView.value;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Agenda",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Explore a agenda completa das partidas do próximo dia de pelada organizadas de acordo com as configurações de duração de partidas, horários de início e término.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.gray_500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      eventDate,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Stack(
                    children:[ 
                      SizedBox(
                        height: (240 * qtdView).toDouble(),
                        child: Column(
                          spacing: 20,
                          children: [
                            ...scheduledGames.take(qtdView).map((game){
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
                      ),
                      //EFEITO DE FADE
                      if(qtdView < qtdGames)...[
                        Positioned(
                          bottom: -10,
                          left: 0,
                          right: 0,
                          height: 250,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.light.withAlpha(20),
                                  AppColors.light,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]
                    ]
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 10,
                      children: [
                        if(qtdView < qtdGames)...[
                          ButtonTextWidget(
                            text: "Ver Mais",
                            width: 80,
                            height: 20,
                            textColor: AppColors.blue_500,
                            backgroundColor: AppColors.green_300,
                            action: () => gameController.setView(true, qtdGames),
                          ),
                        ],
                        if(qtdView > 3)...[
                          ButtonTextWidget(
                            text: "Ver Menos",
                            width: 80,
                            height: 20,
                            textColor: AppColors.blue_500,
                            backgroundColor: AppColors.green_300,
                            action: () => gameController.setView(false, qtdGames),
                          ),
                        ]
                      ],
                    ),
                  ),
                ]
              );
            }),
          ]
        ),
      ),
    );
  }
}