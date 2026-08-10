import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/pages/home/home_page.dart';
import 'package:futzada/presentation/pages/home/home_error_page.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/skeletons/skeleton_home_widget.dart';
import 'package:futzada/presentation/controllers/home_controller.dart';

class HomeBase extends StatelessWidget {
  HomeBase({super.key});
  //CONTROLLERS - NAVEGAÇÃO
  final HomeController homeController = HomeController.instance;
  //RESGATAR USUARIO LOGADO
  final UserModel user = sl<UserModel>(instanceName: 'user');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: HeaderWidget(
        leftAction: () {
          final scaffoldKey = sl<GlobalKey<ScaffoldState>>(instanceName: 'scaffoldKey');
          scaffoldKey.currentState?.openDrawer();
        },
        leftIcon: AppIcones.bars_solid,
        rightAction: () => context.push('/profile'), // TODO: migrar args {id: user.id} quando Phase 2 migrar home
        extraAction: () => context.push('/chats'),
        extraIcon: AppIcones.paper_plane_solid,
        home: true,
        photo: user.photo,
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: ListenableBuilder(listenable: homeController, builder: (_, __){
              if (!homeController.isLoading) {
                if (homeController.hasError) {
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