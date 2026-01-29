import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/utils/user_utils.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/controllers/user_controller.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';
import 'package:futzada/presentation/widget/bars/header_glass_widget.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  //CONTROLLER DE PERFIL
  UserController userController = UserController.instance;
  //RESGATAR DADOS DO USUARIO
  late UserModel user;
  //CONTROLLER DE TABS
  late TabController tabController;
  //CONTROLLER DE SCROLL
  final ScrollController _scrollController = ScrollController();
  //CONTROLLADOR DE TABS FIXAS
  bool _showFixedTabs = false;
  //CONTROLADOR DE INDEX DAS TABS
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    //RESGATAR USUARIO
    user = userController.user;
    //INICIALIZAR CONTROLLER DE TAB
    tabController = TabController(length: 3, vsync: this);
    //INICIAR LISTENER DE SCROLL DA PAGINA
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    tabController.dispose();
    userController.dispose();
    super.dispose();
  }

  //FUNÇÃO PARA CONTROLE DE SCROLL
  void _handleScroll(){
    //RESGATAR POSIÇÃO DA PAGINA 
    final double scrollPosition = _scrollController.position.pixels;
    //VERIFICAR SE POSIÇÃO DA PAGINA  LEVOU SCROLL PARA O TOPO
    if (scrollPosition >= 50 && !_showFixedTabs) {
      //ATUALIZAR CONTROLADOR DE TAB FIXA
      setState(() {
        //DEFINIR TAB COMO FIXO
        _showFixedTabs = true;
      });
      //ATUALIZAR CONTROLLADOR DE TAB FIXA
    } else if (scrollPosition < 50 && _showFixedTabs) {
      setState(() {
        //DEFINIR TAB COMO NÂO FIXO
        _showFixedTabs = false;
      });
    }
  }
    
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //LISTA DE TABS
    List<String> tabs = [
      'Visão Geral',
      'Destaques',
      'Partidas',
    ];
    
    return Scaffold(
      /* appBar: HeaderWidget(
        title: "Perfil",
        leftAction: () => Get.back(),
        rightIcon: Icons.settings,
        rightAction: () => print("config"),
        shadow: false,
        brightness: !_showFixedTabs,
      ),
      extendBodyBehindAppBar: true, */
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              snap: false,
              backgroundColor: _showFixedTabs
                  ? Theme.of(context).primaryColor
                  : Colors.transparent,
              title: Text("Perfil"),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Get.back(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),
            //CARD DE PERFIL DO USUARIO
            SliverList(
              delegate: SliverChildListDelegate([
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            image: DecorationImage(
                              image: const AssetImage(AppImages.cardFootball) as ImageProvider,
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                AppColors.green_300.withAlpha(220), 
                                BlendMode.srcATop,
                              )
                            ),
                          ),
                        ),
                        Container(
                          height: 150,
                        ),
                      ],
                    ),
                    ImgCircularWidget(
                      width: 120,
                      height: 120,
                      image: user.photo, 
                    ),
                    Positioned(
                      bottom: 70,
                      child: Column(
                        children: [
                          Text(
                            UserUtils.getFullName(user),
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if(user.userName != null)...[
                            Text(
                              user.userName!,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: AppColors.grey_300
                              ),
                            ),
                          ]
                        ],
                      )
                    )
                  ],
                )
              ]),
            ),
            //TABS DE NAVEGAÇÃO
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                child: Container(
                  color: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
                  child: TabBar(
                    controller: tabController,
                    onTap: (i) => setState(() => tabIndex = i),
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    tabs: tabs.map((tab){
                      return SizedBox(
                        width: dimensions.width / 3,
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
          children: [
            Container(),
            Container(),
            Container(),
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