import 'package:flutter/material.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/core/helpers/img_helper.dart';
import 'package:esportly/core/helpers/app_helper.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/helpers/modality_helper.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/models/user_model.dart';
import 'package:esportly/data/services/avaliation_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/providers/game/game_schedule_provider.dart';
import 'package:esportly/core/providers/event/event_session_provider.dart';
import 'package:esportly/presentation/pages/event/view/event_overview_page.dart';
import 'package:esportly/presentation/pages/event/view/event_private_page.dart';
import 'package:esportly/presentation/pages/event/view/event_games_page.dart';
import 'package:esportly/presentation/pages/event/view/event_rank_page.dart';
import 'package:esportly/presentation/pages/event/view/event_news_page.dart';
import 'package:esportly/presentation/pages/event/view/event_rules_page.dart';
import 'package:esportly/presentation/pages/event/view/event_participants_page.dart';
import 'package:esportly/presentation/widget/buttons/float_button_widget.dart';
import 'package:esportly/presentation/widget/bars/header_glass_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_icon_widget.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';
import 'package:esportly/presentation/widget/bottomSheet/bottomsheet_event_games.dart';
import 'package:esportly/presentation/widget/bottomSheet/bottomsheet_rule.dart';

class EventPage extends ConsumerStatefulWidget {
  const EventPage({super.key});

  @override
  ConsumerState<EventPage> createState() => _EventPageState();
}

class _EventPageState extends ConsumerState<EventPage> with SingleTickerProviderStateMixin {
  //ESTADO - USUARIO
  UserModel user = sl<UserModel>(instanceName: 'user');
  //CONTROLLER - TABS
  late final TabController tabController = TabController(length: 6, vsync: this);
  int tabIndex = 0;
  //ESTADO - IMAGENS DA PELADA
  bool brightness = false;
  Color textColor = AppColors.white;

  //FUNÇÃO DE DEFINIÇÃO DE HEADER
  PreferredSizeWidget setHeaderBar(index, privacy, color){
    if(index == 0){
      return HeaderGlassWidget(
        title: "Pelada",
        leftAction: () => context.pop(),
        rightIcon: privacy == 'Public' 
          ? AppIcones.cog_solid 
          : null,
        rightAction: () => privacy == 'Public' 
          ? context.push('/event/view/settings') 
          : null,
        brightness: brightness,
      ); 
    }

    return HeaderWidget(
      title: "Pelada",
      backgroundColor: color,
      leftAction: () => context.pop(),
      rightIcon: privacy == 'Public' 
        ? AppIcones.cog_solid 
        : null,
      rightAction: () => privacy == 'Public' 
        ? context.push('/event/view/settings') 
        : null,
      extraIcon: tabController.index == 1 
        ? Icons.history 
        : null,
      extraAction: () => tabController.index == 1 
        ? context.push('/event/view/historic') 
        : null,
      shadow: false,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    final eventSession = ref.read(eventSessionProvider);
    //BUSCAR EVENTO
    EventModel event = eventSession.event!;
    double avaliations = AvaliationService().getRatingAvaliation(event.avaliations);
    Color modalityColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['color'];
    Color modalityTextColor = ModalityHelper.getEventModalityColor(event.gameConfig?.category ?? event.modality!.name)['textColor'];
    ImageProvider modalityImage = ImgHelper.getEventImg(event);
    //ANALISE BRILHO DA IMAGEM DO EVENTO
    AppHelper.isImageDark(modalityImage).then((isDark) {
      setState(() {
        brightness = isDark;
        textColor = isDark ? AppColors.blue_500 : AppColors.white;
      });
    });
    //LISTA DE TABS
    List<String> tabs = [
      'Visão Geral',
      'Partidas',
      'Rank',
      'Participantes',
      'Regras',
      'Notícias'
    ];

    final inProgressNotEmpty = ref.watch(gameScheduleProvider.select((s) => s.inProgressGames.isNotEmpty));
    final hasGames = ref.watch(gameScheduleProvider.select((s) => s.hasGames));

    return Scaffold(
      appBar: setHeaderBar(
        tabController.index,
        eventSession.privacy,
        modalityColor
      ),
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
                    image: modalityImage,
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
                          colors: [
                            AppColors.dark_700.withAlpha(50), 
                            AppColors.dark_700.withAlpha(200)
                          ]
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
                                  avaliations.toStringAsFixed(1),
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
            if(eventSession.participant || eventSession.privacy == "Public")...[
              Container(
                color: Theme.of(context).brightness == Brightness.dark ? Theme.of(context).scaffoldBackgroundColor : AppColors.white,
                child: TabBar(
                  controller: tabController,
                  onTap: (i) => setState(() {
                    tabIndex = i;
                  }),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 5,
                      color: modalityColor,
                    ),
                    insets: EdgeInsets.symmetric(horizontal: dimensions.width / 4)
                  ),
                  labelColor: modalityColor,
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
                            if(inProgressNotEmpty)...[
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
                    EventOverviewPage(),
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
      floatingActionButton: Builder(builder: (_) {
        if (hasGames && tabIndex == 1 && ref.read(gameScheduleProvider.notifier).isToday()) {
          return FloatButtonWidget(
            floatKey: "game_event",
            icon: Icons.play_arrow_rounded,
            backgroundColor: modalityColor,
            color: modalityTextColor,
            onPressed: () => showModalBottomSheet(
              context: context, 
              backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
              builder: (_) => const BottomSheetEventGames()
            )
          );
        }
        if (hasGames && tabIndex == 4) {
          return FloatButtonWidget(
            floatKey: "rules_event",
            icon: Icons.add_rounded,
            backgroundColor: modalityColor,
            color: modalityTextColor,
            onPressed: () => showModalBottomSheet(
              context: context, 
              isScrollControlled: true, 
              backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
              builder: (_) => const BottomSheetRule()
            ),
          );
        }
        return const SizedBox.shrink();
      })
    );
  }
}