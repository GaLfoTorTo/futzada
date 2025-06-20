import 'package:futzada/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/pages/event/view/event_games_page.dart';
import 'package:futzada/pages/event/view/event_home_page.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/float_button_event_widget.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  //DEFINIR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //DEFINIR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //RESGATAR EVENTO ATUAL
  EventModel event = Get.arguments;
  //CONTROLLER DE TABS
  late final TabController tabController;
  //CONTROLADOR DE INDEX DAS TABS
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 6, vsync: this);
    //DEFINIR EVENTO ATUAL NO CONTROLLER
    eventController.setSelectedEvent(event);
    //BINDING DE CARREGAMENTO DA PAGINA
    WidgetsBinding.instance.addPostFrameCallback((_) async{   
      //CARREGAR PARTIDAS DO EVENTO
      gameController.loadGames.value = false;
      gameController.loadGames.value = await gameController.setGamesEvent(event);
      //BUSCAR HISTORICO
      gameController.loadHistoricGames.value = await gameController.getHistoricGames();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE TABS
    List<String> tabs = [
      'Visão Geral',
      'Partidas',
      'Rank',
      'Participantes',
      'Regras',
      'Notícias'
    ];

    return Scaffold(
      appBar: HeaderWidget(
        title: "Pelada",
        leftAction: () => Get.back(),
        rightIcon: AppIcones.cog_solid,
        rightAction: () => print('event settings'),//Get.toNamed('/event/settings'),
        extraIcon: tabController.index == 1 ? Icons.history : null,
        extraAction: () => tabController.index == 1 ? Get.toNamed('/event/historic') : null,
        shadow: false,
      ),
      body: SafeArea(
        child: Column(
          children:[ 
            Container(
              color: AppColors.white,
              child: TabBar(
                controller: tabController,
                onTap: (i) => setState(() {
                  tabIndex = i;
                }),
                indicator: UnderlineTabIndicator(
                  borderSide: const BorderSide(
                    width: 5,
                    color: AppColors.green_300,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: dimensions.width / 4)
                ),
                labelColor: AppColors.green_300,
                labelStyle: const TextStyle(
                  color: AppColors.gray_500,
                  fontWeight: FontWeight.normal,
                ),
                unselectedLabelColor: AppColors.gray_500,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: tabs.map((tab){
                  if(tab == 'Partidas'){
                    return SizedBox(
                      width: 100,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children:[
                          Tab(text: tab),
                          if(gameController.inProgressGames.isNotEmpty)...[
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.red_300,
                                  borderRadius: BorderRadius.circular(50)
                                ),
                              )
                            )
                          ]
                        ]
                      )
                    );
                  }else{
                    return SizedBox(
                      width: 100,
                      height: 50,
                      child: Tab(text: tab)
                    );
                  }
                }).toList()
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  const EventHomePage(),
                  EventGamesPage(
                    tabController: tabController
                  ),
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ), 
          ]
        )
      ),
      floatingActionButton: Obx(() {
        //VERIFICAR SE EXISTEM PROXIMAS PARTIDAS
        if (gameController.hasGames.value && tabIndex == 1) {
          return FloatButtonEventWidget(index: tabController.index);
        }
        return const SizedBox.shrink();
      })
    );
  }
}