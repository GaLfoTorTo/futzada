import 'package:get/get.dart';
import '/theme/app_colors.dart';
import '/theme/app_icones.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/pages/home/home_page.dart';
import 'package:futzada/pages/home/home_error_page.dart';
import 'package:futzada/controllers/app_controller.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/skeletons/skeleton_home_widget.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({super.key});

  @override
  State<HomeBase> createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> with SingleTickerProviderStateMixin {
  //CONTROLLERS - NAVEGAÇÃO E INICIALIZAÇÃO
  final AppController appController = Get.put(AppController());
  final NavigationController navigationController = NavigationController.instance;
  //DEFINIR USUARIO LOGADO
  late UserModel? user;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR APP (CONTROLLER, SERVICES, ETC...)
    appController.initApp();
    //RESGATAR USUARIO
    user = Get.find<UserModel>(tag: 'user');
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        leftAction: () {
          final scaffoldKey = Get.find<GlobalKey<ScaffoldState>>(tag: 'appBaseScaffold');
          scaffoldKey.currentState?.openDrawer();
        },
        leftIcon: AppIcones.bars_solid,
        rightAction: () => print('user'),
        extraAction: () => Get.toNamed('/chats'),
        extraIcon: AppIcones.paper_plane_solid,
        home: true,
        photo: user!.photo,
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Obx(() {
              if (appController.isReady.value) {
                if (appController.hasError.value) {
                  //TELA DE ERRO
                  return const HomeErrorPage();
                }
                if(!appController.isLoading.value){
                  //HOME PAGE
                  return const HomePage();
                }
              }
              //TELA DE CARREGAMENTO
              return const SkeletonHomeWidget();
            })
          ),
        ),
      ),
    );
  }
}