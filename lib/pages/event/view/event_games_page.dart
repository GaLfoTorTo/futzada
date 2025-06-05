import 'package:futzada/widget/cards/card_game_live_widget.dart';
import 'package:futzada/widget/dialogs/erro_partidas_dialog%20copy.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/widget/cards/card_game_widget.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/indicators/indicator_live_widget.dart';

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
  //CONTROLLER DE BARRA NAVEGAÇÃO
  EventController controller = EventController.instace;
  //QUANTIDADE DE ITENS PARA EXIBIÇÃO
  int qtdView = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //VERIFICAR SE EXISTEM PARTIDAS AGENDADAS OU AO VIVO
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //VERIFICAR SE EXISTEM PARTIDAS AGENDADAS OU AO VIVO
      if (controller.nextGames.isEmpty && controller.programaticGames.isEmpty && controller.currentGames.isEmpty) {
        //VERIFICAR SE PAGINA JA FOI MONTADA
        if (mounted) { 
        //EXIBIR DIALOG DE ERRO
          Get.dialog(const ErroPartidasDialog()).then((_) {
            //VERIFICAR SE DIALOG FOI MONTADO
            if (mounted) {
              //RETORNAR PARA PRIMEIRA TAB
              widget.tabController.animateTo(0);
            }
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENT
    EventModel event = controller.event;
    //FUNÇÃO PARA VISUALIZAR MAIS OU MENOS PARTIDAS
    void setView(bool view, int qtdGames){
      //VERIFICAR SE PRECISA EXIBIR OU ESCONDER PARTIDAS
      if(view){
        int increment = qtdGames - qtdView;
        qtdView = increment > 3 ? qtdView + 3 : qtdView + increment;
      }else{
        qtdView = qtdView - 3 > 3 ? qtdView - 3 : 3;
      }
    }

    return SingleChildScrollView(
      child: Container(
        width: dimensions.width,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          children: [
            //EXIBIR CARD DO DIA DE JOGO DO EVENTO
            if(controller.eventDate != null && controller.today.isAtSameMomentAs(controller.eventDate!))...[
              //EXIBIR CARD DE PARTIDA AO VIVO 
              if(controller.currentGames.isNotEmpty)...[
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
                //EXIBIR PARTIDAS AO VIVO
                Obx(() {
                  //RESGATAR PARTIDAS AO VIVO
                  final currentGames = controller.currentGames;
                  //VERIFICAR SE EXISTE PARTIDAS AO VIVO            
                  if (controller.currentGames.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  //RESGATAR QUANTIDADE DE PARTIDAS AO VIVO
                  int qtdGames = currentGames.length;

                  return Column(
                    children: [
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
                            height: (230 * qtdView).toDouble(),
                            child: Column(
                              spacing: 20,
                              children: [
                                ...currentGames.take(qtdView).map((game){

                                  return CardGameLiveWidget(
                                    event: event,
                                    game: game!,
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
                                action: () => setState(() => setView(true, qtdGames)),
                              ),
                            ],
                            if(qtdView > 3)...[
                              ButtonTextWidget(
                                text: "Ver Menos",
                                width: 80,
                                height: 20,
                                textColor: AppColors.blue_500,
                                backgroundColor: AppColors.green_300,
                                action: () => setState(() => setView(false, qtdGames)),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ]
                  );
                }),
              ],
              //EXIBIR PROXIMAS PARTIDAS
              Obx(() {
                //RESGATAR PROXIMAS PARTIDAS
                final nextGames = controller.nextGames;
                //VERIFICAR SE EXISTE PARTIDAS PROGRAMADAS                
                if (controller.nextGames.isEmpty) {
                  return const SizedBox.shrink();
                }
                //RESGATAR QUANTIDADE DE PARTIDAS PROGRAMADAS
                int qtdGames = nextGames.length;

                return Column(
                  children: [
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
                              ...nextGames.asMap().entries.take(qtdView).map((item){
                                //RESGATAR CHAVE E VALOR DO MAPA
                                var key = item.key;
                                //RESGATAR PARTIDA
                                var game = item.value;

                                return CardGameWidget(
                                  width: dimensions.width - 10,
                                  event: event,
                                  game: game!,
                                  navigate: key < 2 ? true : false,
                                  active: key < 2 ? true : false,
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
                              action: () => setState(() => setView(true, qtdGames)),
                            ),
                          ],
                          if(qtdView > 3)...[
                            ButtonTextWidget(
                              text: "Ver Menos",
                              width: 80,
                              height: 20,
                              textColor: AppColors.blue_500,
                              backgroundColor: AppColors.green_300,
                              action: () => setState(() => setView(false, qtdGames)),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ]
                );
              }),
            ],
            //EXIBIR PARTIDAS PROGRAMADAS
            Obx(() {
              final programaticGames = controller.programaticGames;
              //VERIFICAR SE EXISTE PARTIDAS PROGRAMADAS                
              if (controller.programaticGames.isEmpty) {
                return const SizedBox.shrink();
              }
              //RESGATAR DATA DO PROXIMO DIA DO EVENTO
              var eventDate = DateFormat("EEE - dd/MM/y").format(controller.eventDate!);
              //RESGATAR QUANTIDADE DE PARTIDAS PROGRAMADAS
              int qtdGames = programaticGames.length;

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
                            ...programaticGames.take(qtdView).map((game){
                              return CardGameWidget(
                                width: dimensions.width - 10,
                                event: event,
                                game: game!,
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
                            action: () => setState(() => setView(true, qtdGames)),
                          ),
                        ],
                        if(qtdView > 3)...[
                          ButtonTextWidget(
                            text: "Ver Menos",
                            width: 80,
                            height: 20,
                            textColor: AppColors.blue_500,
                            backgroundColor: AppColors.green_300,
                            action: () => setState(() => setView(false, qtdGames)),
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