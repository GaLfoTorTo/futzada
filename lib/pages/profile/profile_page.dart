import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  //CONTROLLER DE PERFIL
  late ProfileController profileController;
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

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER
    profileController = ProfileController(id: Get.arguments['id']);
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 4, vsync: this);
    //INICIAR LISTENER DE SCROLL DA PAGINA
    _scrollController.addListener(_handleScroll);
  }

  //FUNÇÃO PARA CONTROLE DE SCROLL
  void _handleScroll(){
    //RESGATAR POSIÇÃO DA PAGINA 
    final double scrollPosition = _scrollController.position.pixels;
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
    profileController.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR DADOS DO USUARIO
    UserModel user = profileController.user;
    //LISTA DE TABS
    List<String> tabs = [
      'Resumo',
      'Escalações',
      'Estatísticas',
      'Timeline',
    ];
    
    return Scaffold(
      appBar: HeaderWidget(
        title: "@${user.userName}",
        shadow: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            //CARD DE MONITORAMENTO DA PARTIDA
            SliverList(
              delegate: SliverChildListDelegate([
                Container()
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
            //CONTEUDO DAS TABS DE INFORMAÇÕES DA PARTIDA
            SliverFillRemaining(
              child: TabBarView(
                controller: tabController,
                children: [
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
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