import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/cards/card_game_widget.dart';

class EventHistoricPage extends StatefulWidget {
  const EventHistoricPage({super.key});

  @override
  State<EventHistoricPage> createState() => _EventHistoricPageState();
}

class _EventHistoricPageState extends State<EventHistoricPage> with SingleTickerProviderStateMixin {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  EventController controller = EventController.instance;
  //CONTROLLER DE TABS
  late final TabController tabController;
  //LISTA DE TABS
  List<String?> tabs = [];

  @override
  void initState() {
    super.initState();
    //RESGATAR TABS
    tabs = setTabs();
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: tabs.length, vsync: this);
  }

  //FUNÇÃO PARA DEFINIR TABS
  List<String> setTabs() {
    //NOVO ARRAY DE TABS
    final newTabs = <String>[];
    //PERCORRER PARTIDAS PASSADAS
    controller.finishedGames.forEach((game) {
      //VERIFICAR SE JOGO TEM DATA DE CRIAÇÃO
      if (game != null && game.createdAt != null) {
        //FORMATAR DATA
        final date = DateFormat('d/MM').format(game.createdAt!);
        //ADICIONAR DATA AO ARRAY CASO NÃO TENHA
        if (!newTabs.contains(date)) newTabs.add(date);
      }
    });
    //RETORNAR TABS
    return newTabs;
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENT
    EventModel event = controller.event;

    return Scaffold(
      appBar: HeaderWidget(
        title: "Histórico Partidas",
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: Column(
          children:[ 
            if(controller.finishedGames.isNotEmpty)...[
              Container(
                color: AppColors.white,
                child: TabBar(
                  controller: tabController,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 5,
                      color: AppColors.green_300,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: 50)
                  ),
                  labelColor: AppColors.green_300,
                  labelStyle: Theme.of(context).textTheme.bodySmall,
                  unselectedLabelColor: AppColors.gray_500,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: tabs.map((tab){
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: Tab(text: tab)
                    );
                  }).toList()
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: List.generate(tabs.length, (item){
                    //EXIBIR HISTORICO DE PARTIDAS
                    return SingleChildScrollView(
                      child: Container(
                        width: dimensions.width,
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Obx(() {
                              final finishedGames = controller.finishedGames;
                              //VERIFICAR SE EXISTE PARTIDAS PROGRAMADAS                
                              if (controller.finishedGames.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              //RESGATAR DATA DA PARTIDA
                              var gameDate = DateFormat("EEE - dd/MM/y").format(finishedGames[0]!.createdAt!);
                            
                              return Column(
                                children: [
                                  Stack(
                                    children:[ 
                                      SizedBox(
                                        child: Column(
                                          spacing: 20,
                                          children: [
                                            ...finishedGames.take(5).map((game){
                                              
                                              return CardGameWidget(
                                                width: dimensions.width - 10,
                                                event: event,
                                                game: game!,
                                                gameDate: gameDate,
                                                navigate: true,
                                                active: false,
                                                historic: true
                                              );
                                            })
                                          ]
                                        ),
                                      ),
                                    ]
                                  ),
                                ]
                              );
                            }),
                          ]
                        )
                      )
                    );
                  }),
                ),
              ), 
            ]else... [

            ]
          ]
        )
      )
    );
  }
}