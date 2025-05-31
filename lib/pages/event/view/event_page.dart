import 'package:flutter/material.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/pages/event/view/event_games_page.dart';
import 'package:futzada/pages/event/view/event_home_page.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:get/get.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  EventController controller = EventController.instace;
  //CONTROLLER DE ABAS
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 6, vsync: this);
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENTO RECEBIDO POR PARAMETRO
    EventModel event = Get.arguments;
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
        shadow: false,
      ),
      body: SafeArea(
        child: Column(
          children:[ 
            Container(
              color: AppColors.white,
              child: TabBar(
                controller: tabController,
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
                  return SizedBox(
                    width: 100,
                    height: 50,
                    child: Tab(text: tab)
                  );
                }).toList()
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  EventHomePage(event:event),
                  EventGamesPage(event:event),
                  Container(),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ), 
          ]
        )
      )
    );
  }
}