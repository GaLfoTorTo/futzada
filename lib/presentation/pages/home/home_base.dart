import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/pages/home/home_page.dart';
import 'package:futzada/presentation/pages/home/home_error_page.dart';
import 'package:futzada/presentation/controllers/home_controller.dart';
import 'package:futzada/presentation/controllers/navigation_controller.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/skeletons/skeleton_home_widget.dart';

class HomeBase extends StatefulWidget {
  const HomeBase({super.key});

  @override
  State<HomeBase> createState() => _HomeBaseState();
}

class _HomeBaseState extends State<HomeBase> with SingleTickerProviderStateMixin {
  //CONTROLLERS - NAVEGAÇÃO
  final HomeController homeController = HomeController.instance;
  final NavigationController navigationController = NavigationController.instance;
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
      appBar: HeaderWidget(
        leftAction: () {
          final scaffoldKey = Get.find<GlobalKey<ScaffoldState>>(tag: 'appBaseScaffold');
          scaffoldKey.currentState?.openDrawer();
        },
        leftIcon: AppIcones.bars_solid,
        rightAction: () => Get.toNamed('/profile', arguments: {'user' : user}),
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
              if (!homeController.isLoading.value) {
                if (homeController.hasError.value) {
                  //TELA DE ERRO
                  return const HomeErrorPage();
                }
                //HOME PAGE
                return const HomePage();
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