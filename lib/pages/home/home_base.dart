import 'package:get/get.dart';
import '/theme/app_colors.dart';
import '/theme/app_icones.dart';
import 'package:flutter/material.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/pages/home/home_page.dart';
import 'package:futzada/pages/home/home_error_page.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/controllers/home_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/skeletons/skeleton_home_widget.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({super.key});

  @override
  State<HomeBase> createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> with SingleTickerProviderStateMixin {
  //CONTROLLER DE NAVEGAÇÃO
  NavigationController navigationController = NavigationController.instance;
  //CONTROLLER DO HOME PAGE
  HomeController homeController = HomeController.instance;
  //DEFINIR USUARIO LOGADO
  late UserModel? user;

  @override
  void initState() {
    super.initState();
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
            child: FutureBuilder<dynamic>(
              future: homeController.fetchHome(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasError) {
                  //EXIBIR TELA DE ERRO
                  return const HomeErrorPage();
                } else if (snapshot.hasData) {
                  //EXIBIR HOME PAGE
                  return const HomePage();
                } else {
                  //EXIBIR TELA DE CARREGAMENTO
                  return const SkeletonHomeWidget();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}