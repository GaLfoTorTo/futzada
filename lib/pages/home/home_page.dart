import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/theme/app_colors.dart';
import '/theme/app_icones.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/controllers/home_controller.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/controllers/auth_controller.dart';
import 'package:futzada/pages/home/secao/secao_home_widget.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/cards/card_para_voce_widget.dart';
import 'package:futzada/widget/skeletons/skeleton_home_widget.dart';
import 'package:futzada/widget/images/ImgCircularWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  //CONTROLLER DE BARRA NAVEGAÇÃO
  final navigationController = NavigationController.instace;
  final controller = HomeController.instance;
  late UserModel? usuario;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        leftAction: () => navigationController.scaffoldKey.currentState?.openDrawer(),
        leftIcon: AppIcones.bars_solid,
        rightAction: () {},
        rightIcon: AppIcones.paper_plane_solid,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: FutureBuilder<dynamic>(
              future: controller.fetchHome(),
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //EXIBIÇÃO DE CARREGAMENTO DE HOME PAGE
                  return const SkeletonHomeWidget();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  usuario = controller.usuario;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                ImgCircularWidget(
                                  width: 80, 
                                  height: 80, 
                                  image: usuario!.photo
                                ),
                                Positioned(
                                  top: 60,
                                  left: 60,
                                  child: Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                      color: AppColors.green_300,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppHelper.saudacaoPeriodo(),
                                    style: const TextStyle(
                                      color: AppColors.blue_500,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${usuario!.firstName} ${usuario!.lastName}',
                                    style: const TextStyle(
                                      color: AppColors.blue_500,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ]
                  );
                } else {
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