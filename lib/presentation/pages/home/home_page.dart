import 'package:futzada/presentation/widget/cards/card_tasks_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/presentation/widget/showcase/wizard_widget.dart';
import 'package:futzada/presentation/widget/cards/card_ads.dart';
import 'package:futzada/presentation/widget/cards/card_presentation_widget.dart';
import 'package:futzada/presentation/pages/home/secao/section_home_widget.dart';
import 'package:futzada/presentation/pages/home/secao/section_categories_widget.dart';
import 'package:futzada/presentation/controllers/home_controller.dart';
import 'package:futzada/presentation/controllers/showcase_controller.dart';
import 'package:futzada/presentation/controllers/user_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //CONTROLLERS - HOME
  HomeController homeController = HomeController.instance;
  UserController userController = UserController.instance;
  ShowcaseController showcaseController = ShowcaseController.instance;
  //DEFINIR USUARIO LOGADO
  late UserModel? user;

  @override
  void initState() {
    super.initState();
    //RESGATAR USUARIO
    user = userController.user;
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx((){
          //SHOWCASE TUTORIAL (START)
          return WizardWidget(
            elementKey: showcaseController.currentShowcase.value == 'start' ? 'start' : 'end',
            child: const SizedBox.shrink()
          );
        }),
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
        //SEÇÃO - TASKS
        if(!userController.profileCompleted.value)...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CardTasksWidget(
              user: user!
            ),
          )
        ],
        //SEÇÃO - EVENTO DO DIA
        if(homeController.events.isNotEmpty)...[
          SectionHomeWidget(
            title: "Meus Eventos",
            options: homeController.events,
          )
        ],
        //SEÇÃO - ADS/PROPAGANDAS
        if(homeController.ads.isNotEmpty)...[
          const CardAds()
        ],
        //SEÇÃO - PERTO DE VOCE
        if(homeController.toYou.isNotEmpty)...[
          SectionHomeWidget(
            title: "Perto de Você",
            options: homeController.toYou, 
          )
        ],
        //SEÇÃO - POPULARES
        if(homeController.popular.isNotEmpty)...[
          SectionHomeWidget(
            title: "Mais Populares",
            options: homeController.popular, 
          )
        ],
        //SEÇÃO - HOJE
        if(homeController.today.isNotEmpty)...[
          SectionHomeWidget(
            title: "Acontece Hoje",
            options: homeController.today, 
          )
        ],
        //SEÇÃO - SUGESTÃO DE AMIGOS
        if(homeController.popular.isNotEmpty)...[
          SectionHomeWidget(
            title: "Talvez você conheça",
            options: homeController.suggestionFriends, 
          )
        ],
      ]
    );
  }
}