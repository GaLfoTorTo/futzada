import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/pages/erros/erro_historic_game_page.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/widget/skeletons/skeleton_games_widget.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/cards/card_game_widget.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';

class EventHistoricPage extends StatefulWidget {
  const EventHistoricPage({super.key});

  @override
  State<EventHistoricPage> createState() => _EventHistoricPageState();
}

class _EventHistoricPageState extends State<EventHistoricPage> with SingleTickerProviderStateMixin {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  EventController eventController = EventController.instance;
  //DEFINIR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //ESTADO - EVENTO
  late EventModel event;
  //CONTROLLER DE TABS
  late TabController _tabController;
  //LISTA DE TABS
  List<String?> tabs = [];
  //CONTROLADOR DE EXIBIÇÃO
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //RESGATAR EVENT
    event = eventController.event;
    //VERIFICAR SE PARTIDAS FORAM CARREGADAS
    if(gameController.finishedGames.isNotEmpty){
      tabs = gameController.finishedGames.keys.toList();
      //INICIALIZAR CONTROLLER DE TABS
      _tabController = TabController(length: tabs.length, vsync: this);
    }else{
      //INICIALIZAR CONTROLLER DE TABS VAZIO
      _tabController = TabController(length: 1, vsync: this);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: "Histórico",
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: Obx(() {
          print(gameController.finishedGames);
          print(tabs);
          //EXIBIR SKELETON DE CARREGAMENTO
          if (!gameController.loadHistoricGames.value) {
            return const SkeletonGamesWidget();
          }

          //EXIBIR MENSAGEM DE ERRO CASO NÃO EXISTAM PARTIDAS
          if (gameController.finishedGames.isEmpty && tabs.isEmpty) {
            return const ErroHistoricGamePage();
          }
          //EXIBIR MENSAGEM DE ERRO CASO NÃO EXISTAM PARTIDAS
          if (gameController.finishedGames.isNotEmpty && tabs.isNotEmpty) {
            // CONTEÚDO COM TABS
            return Column(
              children: [
                Container(
                  color: AppColors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicator: UnderlineTabIndicator(
                      borderSide: const BorderSide(
                        width: 5,
                        color: AppColors.green_300,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: dimensions.width / 4),
                    ),
                    labelColor: AppColors.green_300,
                    labelStyle: const TextStyle(
                      color: AppColors.gray_500,
                      fontWeight: FontWeight.normal,
                    ),
                    unselectedLabelColor: AppColors.gray_500,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: tabs.map((tab) {
                      return SizedBox(
                        width: 100,
                        height: 50,
                        child: Tab(text: tab),
                      );
                    }).toList(),
                  ),
                ),
                // USAR EXPANDED PARA OCUPAR O RESTO DA TELA
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: gameController.finishedGames.entries.map((entry) {
                      final List<GameModel>? listGames = entry.value;

                      return ListView(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        children: listGames!.map((game) {
                          return CardGameWidget(
                            width: dimensions.width - 20,
                            event: event,
                            game: game,
                            gameDate: DateFormat("EEE - dd/MM/y").format(game.createdAt!),
                            navigate: true,
                            active: false,
                            historic: true,
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        }),
      ),
    );
  }
}