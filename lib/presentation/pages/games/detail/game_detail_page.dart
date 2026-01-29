import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/presentation/controllers/game_controller.dart';
import 'package:futzada/presentation/pages/games/detail/game_escalation_page.dart';
import 'package:futzada/presentation/pages/games/detail/game_overview_page.dart';
import 'package:futzada/presentation/pages/games/detail/game_statistics_page.dart';
import 'package:futzada/presentation/pages/games/detail/game_timeline_page.dart';
import 'package:futzada/presentation/widget/bars/header_scroll_widget.dart';
import 'package:futzada/presentation/widget/buttons/float_button_widget.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_alert_start.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_stop_watch.dart';
import 'package:futzada/presentation/widget/cards/card_game_detail_widget.dart';
import 'package:futzada/presentation/widget/buttons/float_button_timer_widget.dart';

class GameDetailPage extends StatefulWidget {
  const GameDetailPage({super.key});

  @override
  State<GameDetailPage> createState() => GameDetailPageState();
}

class GameDetailPageState extends State<GameDetailPage> with SingleTickerProviderStateMixin {
  //RESGATAR CONTROLLER DE PARTIDAS
  GameController gameController = GameController.instance;
  //DEFINIR EVENTO
  late EventModel event;
  //CONTROLLER DE TABS
  late TabController tabController;
  //CONTROLLER DE SCROLL
  final ScrollController scrollController = ScrollController();
  //ESTADOS -INDEX, TABS, SCROLL
  RxDouble tabMargin = 10.0.obs;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 4, vsync: this);
    //RESGATAR EVENTO 
    event = gameController.event;
    //INICIAR LISTENER DE SCROLL DA PAGINA
    scrollController.addListener(handleScroll);
    //SIMULAR JOGADORES PRESENTES
    gameController.addParticipantsPresents();
    //VERIFICAR SE CONFIGURAÇÕES E EQUIPES DA PARTIDA ESTÃO PRONTOS 
    WidgetsBinding.instance.addPostFrameCallback((_){
      if (!gameController.isGameReady.value && !Get.isDialogOpen!) {
        Get.dialog(const DialogAlertStart());
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  //FUNÇÃO PARA CONTROLE DE SCROLL
  void handleScroll(){
    //RESGATAR POSIÇÃO DA PAGINA 
    final double scrollPosition = scrollController.position.pixels;
    //VERIFICAR SE POSIÇÃO DA PAGINA  LEVOU SCROLL PARA O TOPO
    if (scrollPosition >= 300) {
      //ATUALIZAR CONTROLADOR DE TAB FIXA
      tabMargin.value = 0;
      //ATUALIZAR CONTROLLADOR DE TAB FIXA
    } else {
      tabMargin.value = 10;
    }
  }
    
  @override
  Widget build(BuildContext context) {
    //LISTA DE TABS
    List<String> tabs = [
      'Resumo',
      'Escalações',
      'Estatísticas',
      'Timeline',
    ];
    
    return Scaffold(
      body: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          
          return [
            HeaderScrollWidget(
              title: "Partida #${gameController.currentGame.number}",
              leftAction: () => Get.back(),
              rightIcon: AppIcones.cog_solid,
              rightAction: () {
                //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
                Get.toNamed('/games/config', arguments: {
                  'game': gameController.currentGame,
                });
              },
            ),
            //CARD DE MONITORAMENTO DA PARTIDA
            SliverList(
              delegate: SliverChildListDelegate([
                CardGameDetailWidget(
                  event: event,
                  game: gameController.currentGame
                )
              ]),
            ),
            //TABS DE INFORMAÇÕES DA PARTIDA
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                child: Obx((){
                  return Container(
                    color: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
                    margin: EdgeInsets.symmetric(horizontal: tabMargin.value),
                    child: TabBar(
                      controller: tabController,
                      onTap: (i) => setState(() => tabIndex = i),
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
                  );
                })
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: const [
            GameOverviewPage(),
            GameEscalationPage(),
            GameStatisticsPage(),
            GameTimelinePage(),
          ],
        ),
      ),
      floatingActionButton: Obx((){
        if(gameController.isGameReady.value && tabIndex == 0){
          return FloatButtonTimerWidget(
            actionButton: () => Get.dialog(const StopWatchDialog(),
              barrierColor: Colors.transparent,
              useSafeArea: true,
              transitionDuration: Durations.short1
            ),
            isRunning: gameController.isGameRunning.value,
          );
        }
        if(!gameController.isGameReady.value){
          return FloatButtonWidget(
            onPressed: () => Get.toNamed("/games/teams"),
            floatKey: "teams_games",
            icon: AppIcones.escalacao_outline,
          );
        }
        return const SizedBox.shrink();
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  double get minExtent => 50;
  @override
  double get maxExtent => 50;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}