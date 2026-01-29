import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/pages/event/view/event_news_page.dart';
import 'package:futzada/presentation/pages/event/view/event_rules_page.dart';
import 'package:futzada/presentation/widget/buttons/float_button_widget.dart';
import 'package:futzada/presentation/widget/bottomSheet/bottomsheet_event_games.dart';
import 'package:futzada/presentation/widget/bottomSheet/bottomsheet_rule.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/utils/img_utils.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/widget/bars/header_glass_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_icon_widget.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/pages/event/view/event_home_page.dart';
import 'package:futzada/presentation/pages/event/view/event_private_page.dart';
import 'package:futzada/presentation/pages/event/view/event_games_page.dart';
import 'package:futzada/presentation/pages/event/view/event_rank_page.dart';
import 'package:futzada/presentation/pages/event/view/event_participants_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> with SingleTickerProviderStateMixin {
  //CONTROLLERS
  EventController eventController = EventController.instance;
  GameController gameController = GameController.instance;
  //USUARIO ATUAL
  UserModel user = Get.find(tag: "user");
  //EVENTO ATUAL
  EventModel event = Get.arguments['event'];
  //CONTROLLER - TABS
  late final TabController tabController;
  int tabIndex = Get.arguments['index'] ?? 0;
  //ESTADOS - ITEMS DO EVENTO
  bool isParticipant = false;
  late ImageProvider eventImage;
  late String eventVisibility;
  late double eventAvaliations;
  //ESTADO - IMAGENS DA PELADA
  bool brightness = false;
  Color textColor = AppColors.white;

  @override
  void initState() {
    super.initState();
    //VERIFICAR SE USUARIO ESTA PARTICIPANDO DO EVENTO ATUAL
    eventController.events.map((event){
      isParticipant = event.participants?.firstWhere((u) => u.id == user.id) != null;
    });
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 6, vsync: this);
    //ATUALIZAR ITEMS DO EVENTOS
    eventImage = ImgUtils.getEventImg(event.photo);
    eventVisibility = event.visibility!.name;
    eventAvaliations = 4.2;//eventController.eventService.getEventAvaliation(event.avaliations);
    //DEFINIR EVENTO ATUAL NO CONTROLLER
    eventController.setSelectedEvent(event);
    //ANALISE BRILHO DA IMAGEM DO EVENTO
    AppHelper.isImageDark(eventImage).then((isDark) {
      setState(() {
        brightness = isDark;
        textColor = isDark ? AppColors.blue_500 : AppColors.white;
      });
    });
  }

  PreferredSizeWidget setHeaderBar(index){
    if(index == 0){
      return HeaderGlassWidget(
        title: "Pelada",
        leftAction: () => Get.back(),
        rightIcon: eventVisibility == 'Public' 
          ? AppIcones.cog_solid 
          : null,
        rightAction: () => eventVisibility == 'Public' 
          ? Get.toNamed('/event/settings') 
          : null,
        brightness: brightness,
      ); 
    }

    return HeaderWidget(
      title: "Pelada",
      leftAction: () => Get.back(),
      rightIcon: eventVisibility == 'Public' 
        ? AppIcones.cog_solid 
        : null,
      rightAction: () => eventVisibility == 'Public' 
        ? Get.toNamed('/event/settings') 
        : null,
      extraIcon: tabController.index == 1 
        ? Icons.history 
        : null,
      extraAction: () => tabController.index == 1 
        ? Get.toNamed('/event/historic') 
        : null,
      shadow: false,
    );
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
      appBar: setHeaderBar(tabController.index),
      extendBodyBehindAppBar: tabController.index == 0,
      body: 
        Column(
          children:[ 
            if(tabController.index == 0)...[
              Container(
                width: dimensions.width,
                height: dimensions.height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: eventImage,
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children:[
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.dark_700.withAlpha(20), AppColors.dark_700.withAlpha(150)]
                        )
                      ),
                    ),
                    Container(
                      width: dimensions.width * 0.6,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                AppIcones.star_solid,
                                color: AppColors.yellow_500,
                                size: 25,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(
                                  eventAvaliations.toStringAsFixed(1),
                                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                    color: textColor
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            "${event.title}",
                            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: textColor
                            ),
                          ),
                          Row(
                            children: [
                              ButtonIconWidget(
                                icon: Icons.bookmark,
                                iconSize: 20,
                                iconColor: brightness ? AppColors.dark_500 : AppColors.white,
                                backgroundColor: AppColors.white.withAlpha(15),
                                action: () {},
                              ),
                              ButtonIconWidget(
                                icon: Icons.star,
                                iconSize: 20,
                                iconColor: brightness ? AppColors.dark_500 : AppColors.white,
                                backgroundColor: AppColors.white.withAlpha(15),
                                action: () {},
                              ),
                              ButtonIconWidget(
                                icon: Icons.share,
                                iconSize: 20,
                                iconColor: brightness ? AppColors.dark_500 : AppColors.white,
                                backgroundColor: AppColors.white.withAlpha(15),
                                action: () {},
                              ),
                            ]
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ],
            if(isParticipant || eventVisibility == "Public")...[
              Container(
                color: Get.isDarkMode ? Theme.of(context).scaffoldBackgroundColor : AppColors.white,
                child: TabBar(
                  controller: tabController,
                  onTap: (i) => setState(() {
                    tabIndex = i;
                  }),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 5,
                      color: Theme.of(context).primaryColor,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: dimensions.width / 4)
                  ),
                  labelColor: Theme.of(context).primaryColor,
                  labelStyle: const TextStyle(
                    color: AppColors.grey_500,
                    fontWeight: FontWeight.normal,
                  ),
                  unselectedLabelColor: AppColors.grey_500,
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
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [
                  EventHomePage(),
                  EventGamesPage(),
                  EventRankPage(),
                  EventParticipantsPage(),
                  EventRulesPage(),
                  EventNewsPage(),
                ],
              ),
            ), 
            ]else...[
              const EventPrivatePage()
            ]
          ]
      ),
      floatingActionButton: Obx(() {
        //FLOAT ACTION BUTTON DE PARTIDAS
        if (gameController.hasGames.value && tabIndex == 1 && gameController.isToday()) {
          return FloatButtonWidget(
            floatKey: "game_event",
            icon: Icons.play_arrow_rounded,
            onPressed:  () => Get.bottomSheet(const BottomSheetEventGames())
          );
        }
        //FLOAT ACTION BUTTON DE REGRAS
        if (gameController.hasGames.value && tabIndex == 4) {
          return FloatButtonWidget(
            floatKey: "rules_event",
            icon: Icons.add,
            onPressed: () => Get.bottomSheet(const BottomSheetRule(), isScrollControlled: true),
          );
        }
        return const SizedBox.shrink();
      })
    );
  }
}