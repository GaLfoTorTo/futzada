import 'package:futzada/presentation/controllers/profile_controller.dart';
import 'package:futzada/presentation/pages/profile/profile_overview_page.dart';
import 'package:futzada/presentation/widget/skeletons/skeleton_profile_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/helpers/user_helper.dart';
import 'package:futzada/core/helpers/modality_helper.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/widget/buttons/button_icon_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
import 'package:futzada/presentation/widget/images/img_group_circle_widget.dart';
import 'package:futzada/presentation/widget/images/img_circle_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  //CONTROLLER
  ProfileController profileController = Get.put(ProfileController());

  //ESTADO - USUARIO
  UserModel authUser = Get.find<UserModel>(tag: 'user');
  late UserModel user;
  late bool isUserProfile;

  late Worker userWorker;
  //ESTADO - ITEMS EVENTO
  late Color modalityColor;
  late Color modalityTextColor;
  late String modalityImage;
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
    //INICIALIZAR CONTROLLER DE PERFIL
    profileController.getProfile(Get.arguments['id']);
    //ESPERAR BUSCA DOS DADOS DO USUARIO
    userWorker = ever<bool>(profileController.isLoaded, (userReady) async {
      if (!userReady) return;
      user = profileController.user;
      //VERIFICAR SE É O PERFIL DO USUARIO LOGADO
      isUserProfile = user.id == authUser.id;
      //ESTADO - ITEMS EVENTO
      modalityColor = ModalityHelper.getEventModalityColor(profileController.user.config!.mainModality!.name)['color'];
      modalityTextColor = ModalityHelper.getEventModalityColor(profileController.user.config!.mainModality!.name)['textColor'];
      modalityImage = ModalityHelper.getEventModalityColor(profileController.user.config!.mainModality!.name)['image'];
      //ATUALIZAR FLAG DE PRONTO
      profileController.isReady.value = true;
      //ENCERRAR WORKERS
      userWorker.dispose();
    });
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
    profileController.dispose();
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

  //LISTA DE TABS
  List<String> tabs = [
    'Visão Geral',
    'Destaques',
    'Partidas',
  ];

  //LISTA DE INFORMAÇÕES DO USUARIO
  List<Map<String, dynamic>> info = [
    {'label': 'Destaques', "icon": Icons.highlight ,"value": 35},
    {'label': 'Amigos', "icon": Icons.people ,"value": 35},
    {'label': 'Conquistas', "icon": AppIcones.medal_solid ,"value": 5},
  ];
    
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Scaffold(
      body:  Obx((){
        if(!profileController.isReady.value){
          return const SkeletonProfileWidget();
        }
        return NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                backgroundColor: modalityColor,
                title: const Text("Perfil"),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                ),
                actions: [
                  if(isUserProfile)...[
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {},
                    ),
                  ]
                ],
              ),
              //CARD DE PERFIL DO USUARIO
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
                    height: isUserProfile ? 420 : 500,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                                image: DecorationImage(
                                  image: AssetImage(modalityImage) as ImageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(
                                    modalityColor.withAlpha(220), 
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
                        Column(
                          children: [
                            const SizedBox(height: 80),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  ImgCircularWidget(
                                    size: 120,
                                    image: user.photo, 
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        UserHelper.getFullName(user),
                                        style: Theme.of(context).textTheme.headlineSmall,
                                      ),
                                      if(user.userName != null)...[
                                        Text(
                                          "@${user.userName}",
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                            color: AppColors.grey_300
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                  SizedBox(
                                    width: dimensions.width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ButtonIconWidget(
                                          padding: 20,
                                          icon: Icons.share_rounded,
                                          iconColor: Theme.of(context).textTheme.headlineSmall!.color,
                                          backgroundColor: Theme.of(context).cardTheme.color,
                                          borderColor: Theme.of(context).textTheme.headlineSmall!.color,
                                          action: (){}
                                        ),
                                        ButtonTextWidget(
                                          width: dimensions.width * 0.5,
                                          text: "Adicionar",
                                          icon: Icons.person_add_rounded,
                                          backgroundColor: modalityColor,
                                          action: (){},
                                        ),
                                        ButtonIconWidget(
                                          padding: 20,
                                          icon: AppIcones.paper_plane_solid,
                                          iconColor: Theme.of(context).textTheme.headlineSmall!.color,
                                          backgroundColor: Theme.of(context).cardTheme.color,
                                          borderColor: Theme.of(context).textTheme.headlineSmall!.color,
                                          action: (){}
                                        )
                                      ],
                                    ),
                                  ),
                                  if(!isUserProfile)...[
                                    Text(
                                      "Amigos em Comun",
                                      style: Theme.of(context).textTheme.displayMedium,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ImgGroupCircularWidget(
                                          size: 50,
                                          borderColor: Theme.of(context).textTheme.headlineSmall!.color,
                                          images: null,
                                        ),
                                      ],
                                    ),
                                  ],
                                  const Divider(),
                                  SizedBox(
                                    width: dimensions.width,
                                    child: Row(
                                      spacing: 10,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: info.map((item){
                                        return Column(
                                          children: [
                                            Text(
                                              item['value'].toString(),
                                              style: Theme.of(context).textTheme.headlineMedium,
                                            ),
                                            Row(
                                              spacing: 5,
                                              children: [
                                                Icon(
                                                  item['icon'],
                                                  color: AppColors.grey_300,
                                                  size: 20
                                                ),
                                                Text(
                                                  item['label'],
                                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                                    color: AppColors.grey_300
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            width: 5,
                            color: modalityColor,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: dimensions.width / 3)
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
              const ProfileOverviewPage(),
              Container(),
              Container(),
            ],
          ),
        );
      })
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