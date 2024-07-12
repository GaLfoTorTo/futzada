import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:futzada/widget/drawers/drawer_widget.dart';
import '/theme/app_colors.dart';
import '/theme/app_icones.dart';
import '/theme/app_images.dart';
import '/widget/bars/header_widget.dart';
import '/widget/images/ImgCircularWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //REF PARA DRAWER
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //FUNÇÃO PARA ABRIR E FECHAR DRAWER
  void toggleDrawer(isDrawerOpen) {
      if(isDrawerOpen){
        _scaffoldKey.currentState?.openDrawer();
      }else{
        _scaffoldKey.currentState?.closeDrawer();
      };
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.light,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: HeaderWidget(
          iconLeft: AppIcones.menu["fas"],
          actionLeft: () => toggleDrawer(true),
          iconRight: AppIcones.direct["fas"],
          actionRight: () => print('OPEN CHAT'),//OPEN CHAT
        )
      ),
      onDrawerChanged: (isOpened) => toggleDrawer(isOpened),
      drawer: DrawerWidget(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Stack(
                  children: [
                    const ImgCircularWidget(width: 80, height: 80, image: AppImages.user_default),//ADICIONAR IMAGEM DO USUARIO
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
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Boa Noite",//ADICIONAR SAUDAÇÃO
                        style: TextStyle(
                          color: AppColors.blue_500,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Nome do Usuário",//ADICIONAR NOME DO USUARIO
                        style: TextStyle(
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
        ],
      ),
    );
  }
}