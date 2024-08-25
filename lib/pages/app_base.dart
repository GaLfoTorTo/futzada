import 'package:flutter/material.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/pages/escalacao/escalacao_page.dart';
import 'package:futzada/pages/explore/explore_page.dart';
import 'package:futzada/pages/home/home_page.dart';
import 'package:futzada/pages/notificacoes/notificacoes_page.dart';
import 'package:futzada/pages/pelada/registro/pelada_apresentacao.dart';
import 'package:futzada/providers/usuario_provider.dart';
import 'package:futzada/widget/drawers/drawer_widget.dart';
import 'package:futzada/widget/tabs/tab_bar_widget.dart';
import 'package:provider/provider.dart';
import '/theme/app_colors.dart';

class AppBase extends StatefulWidget {
  const AppBase({super.key});

  @override
  State<AppBase> createState() => _AppBaseState();
}

class _AppBaseState extends State<AppBase> with SingleTickerProviderStateMixin {
  //REF PARA DRAWER
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  //CONTROLLER DE AUTENTICAÇÃO
  AuthController authController = AuthController();
  //CONTROLLER DE TAB BAR
  late TabController tabController;
  int activeTab = 0;
  String? iconBack = '';
  String? currentRoute = '';
  //BUSCAR USUARIO PROVIDER
  late UsuarioProvider usuarioProvider;
  late var usuario;
  
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    //BUSCAR OS DADOS DO PROVIDER 
    usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    //RESGATAR USUARIO
    usuario = usuarioProvider.usuario;
  }

  //FUNÇÃO PARA ABRIR E FECHAR DRAWER MENU
  void toggleDrawerMenu(isDrawerOpen) {
    if(isDrawerOpen){
      _scaffoldKey.currentState?.openDrawer();
    }else{
      _scaffoldKey.currentState?.closeDrawer();
    };
  }

  //FUNÇÃO PARA ABRIR E FECHAR DRAWER CHAT
  void toggleDrawerChat(isDrawerOpen) {
    if(isDrawerOpen){
      _scaffoldKey.currentState?.openDrawer();
    }else{
      _scaffoldKey.currentState?.closeDrawer();
    };
  }

  //FUNÇÃO PARA ALTERAR TABS 
  void alterTabs(){
    setState(() {
      tabController.index = 0;
      activeTab = 0;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.light,
      onDrawerChanged: (isOpened) => toggleDrawerMenu(isOpened),
      drawer: const DrawerWidget(),
      bottomNavigationBar: TabBarWidget(
        controller: tabController,
        active: tabController.index,
      ),
      body: TabBarView(
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(menuFunction: toggleDrawerMenu, chatFunction: toggleDrawerMenu,),
          EscalacaoPageState(
            actionButton: alterTabs,
          ),
          PeladaApresentacaoState(
            actionButton: alterTabs,
          ),
          ExplorePageState(
            actionButton: alterTabs,
          ),
          NotificacaoPageState(
            actionButton: alterTabs,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}