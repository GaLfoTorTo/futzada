import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/pages/games/detail/game_escalation_page.dart';
import 'package:futzada/pages/games/detail/game_overview_page.dart';
import 'package:futzada/pages/games/detail/game_statistics_page.dart';
import 'package:futzada/pages/games/detail/game_timeline_page.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/dialogs/stop_watch_dialog.dart';
import 'package:futzada/widget/cards/card_game_detail_widget.dart';
import 'package:futzada/widget/buttons/float_button_timer_widget.dart';

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
  final ScrollController _scrollController = ScrollController();
  //CONTROLLADOR DE TABS FIXAS
  bool _showFixedTabs = false;
  //CONTROLADOR DE INDEX DAS TABS
  int tabIndex = 0;
  //CONTROLLADOR DE MARGIN DAS TABS
  double tabMargin = 10;
  //CONTROLADOR DE POSIÇÃO DO BOTÃO
  FloatingActionButtonLocation _fabLocation = FloatingActionButtonLocation.centerFloat;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 4, vsync: this);
    //RESGATAR EVENTO 
    event = gameController.event;
    //INICIAR LISTENER DE SCROLL DA PAGINA
    _scrollController.addListener(_handleScroll);
  }

  //FUNÇÃO PARA CONTROLE DE SCROLL
  void _handleScroll(){
    //RESGATAR POSIÇÃO DA PAGINA 
    final double scrollPosition = _scrollController.position.pixels;
    //VERIFICAR VALOR DE SCROLL 
    if (scrollPosition > 50 && _fabLocation != FloatingActionButtonLocation.endFloat) {
      //ATUALIZAR POSIÇÃO DO FLOAT ACTION BUTTON
      setState(() {
        _fabLocation = FloatingActionButtonLocation.endFloat;
      });
    } else if (scrollPosition <= 50 && _fabLocation != FloatingActionButtonLocation.centerFloat) {
      //ATUALIZAR POSIÇÃO DO FLOAT ACTION BUTTON
      setState(() {
        _fabLocation = FloatingActionButtonLocation.centerFloat;
      });
    }
    //VERIFICAR SE POSIÇÃO DA PAGINA  LEVOU SCROLL PARA O TOPO
    if (scrollPosition >= 300 && !_showFixedTabs) {
      //ATUALIZAR CONTROLADOR DE TAB FIXA
      setState(() {
        //DEFINIR MARGIN DAS TABS
        tabMargin = 0;
        //DEFINIR TAB COMO FIXO
        _showFixedTabs = true;
      });
      //ATUALIZAR CONTROLLADOR DE TAB FIXA
    } else if (scrollPosition < 300 && _showFixedTabs) {
      setState(() {
        //DEFINIR MARGIN DAS TABS
        tabMargin = 10;
        //DEFINIR TAB COMO NÂO FIXO
        _showFixedTabs = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE TABS
    List<String> tabs = [
      'Resumo',
      'Escalações',
      'Estatísticas',
      'Timeline',
    ];
    
    return Scaffold(
      appBar: HeaderWidget(
        title: "Partida #${gameController.currentGame.number}",
        leftAction: () => Get.back(),
        rightIcon: AppIcones.cog_solid,
        rightAction: () {
          //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
          Get.toNamed('/games/config', arguments: {
            'game': gameController.currentGame,
            'event': event,
            'index': 1,
          });
        },
        shadow: !_showFixedTabs,
      ),
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
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
                  child: Container(
                    color: AppColors.white,
                    margin: EdgeInsets.symmetric(horizontal: tabMargin),
                    child: TabBar(
                      controller: tabController,
                      onTap: (i) => setState(() => tabIndex = i),
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
      ),
      floatingActionButton: Obx((){
        if(tabIndex != 0){
          return SizedBox.shrink();
        }
        return FloatButtonTimerWidget(
          actionButton: () => Get.dialog(StopWatchDialog(),
            barrierColor: Colors.transparent,
            useSafeArea: true,
            transitionDuration: Durations.short1
          ),
          isRunning: gameController.isGameRunning.value,
        );
      }),
      floatingActionButtonLocation: _fabLocation,
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