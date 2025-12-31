
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/models/user_model.dart';
import 'package:futzada/widget/cards/card_ads.dart';
import 'package:futzada/widget/cards/card_presentation_widget.dart';
import 'package:futzada/controllers/home_controller.dart';
import 'package:futzada/pages/home/secao/section_home_widget.dart';
import 'package:futzada/pages/home/secao/section_categories_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //CONTROLLERS -HOME, EVENTS, GAME
  HomeController homeController = HomeController.instance;
  EventController eventController = EventController.instance;
  GameController gameController = GameController.instance;
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
    return Column(
      children: [
        //CARD USUARIO
        Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: AppColors.green_300,
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(45), bottomRight: Radius.circular(45)),
            boxShadow: [
              BoxShadow(
                color: AppColors.dark_500.withAlpha(50),
                spreadRadius: 0.5,
                blurRadius: 5,
                offset: const Offset(2, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              CardPresentationWidget(user: user),
            ]
          )
        ),
        //SEÇÃO - CATEGORIAS
        const SectionCategoriesWidget(),
        //SEÇÃO - EVENTO DO DIA
        if(gameController.isToday())...[
          SectionHomeWidget(
            titulo: "Dia de Jogo",
            options: eventController.myEvents,
          )
        ],
        //SEÇÃO - ADS/PROPAGANDAS
        if(homeController.ads.isNotEmpty)...[
          const CardAds()
        ],
        //SEÇÃO - PERTO DE VOCE
        if(homeController.toYou.isNotEmpty)...[
          SectionHomeWidget(
            titulo: "Perto de Você",
            options: homeController.toYou, 
          )
        ],
      ]
    );
  }
}