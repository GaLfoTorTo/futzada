import 'package:flutter/material.dart';
import 'package:futzada/pages/notification/notification_page.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:futzada/pages/presentation_page.dart';
import 'package:futzada/pages/home/home_page.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class NavigationController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static NavigationController get instace => Get.find();
  //SCAFFOLD KEY
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void onInit() {
    super.onInit();
    //ADICIONAR KEY DO SCAFFOLD GLOBALMENT AO GET
    Get.put(scaffoldKey, tag: 'appBaseScaffold', permanent: true);
  }
  //CONTROLADOR DE INDEX NAVIGATION BAR
  final Rx<int> index = 0.obs; 
  //FUNÇÃO DE ATUALIZAÇÃO DE INDEX
  void directIndex(int newIndex) {
    index.value = newIndex;
  }
  //FUNÇÃO DE INCREMENTAÇÃO DE INDEX
  void nextIndex() {
    index.value = index.value + 1;
  }
  //FUNÇÃO DE DECREMENTAÇÃO DE INDEX
  void backIndex() {
    index.value = index.value - 1;
  }
  //FUNÇÃO DE RETORNO PARA HOME
  void backHome(BuildContext context) {
    Get.dialog(
      Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Cancelar Cadastro',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Deseja cancelar o cadastro da pelada voltar para a página inicial ?',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonTextWidget(
                    text: "Não",
                    width: 50,
                    height: 20,
                    action: () => Get.back(),
                    backgroundColor: AppColors.red_300,
                    textColor: AppColors.white,
                  ),
                  ButtonTextWidget(
                    text: "Sim",
                    width: 50,
                    height: 20,
                    action: () {
                      index.value = 0;
                      Get.offAllNamed('/home');
                    },
                    backgroundColor: AppColors.green_300,
                    textColor: AppColors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  //TELAS DE ESCALAÇÃO
  final screens = [
    //HOME PAGE
    const HomePage(),
    //APRENSENTAÇÃO PAGE ESCALAÇÕES
    PresentationPageWidget(
      image: AppImages.capaEscalacao,
      route: 'Escalação',
      titulo: 'Monte o sua equipe ideal da pelada',
      subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
      buttonFirstText: 'Escalação',
      buttonFirstIcon: AppIcones.clipboard_solid,
      buttonSecoundText: 'Partidas',
      buttonSecoundIcon: AppIcones.escalacao_outline,
      buttonFirstAction: () => Get.toNamed('/escalation'),
      buttonSecoundAction: () => Get.toNamed('/games/list'),
    ),
    //APRENSENTAÇÃO PAGE PELADAS
    PresentationPageWidget(
      image: AppImages.capaEvent,
      route: 'Peladas',
      titulo: 'Nunca foi tão facil organizar suas peladas',
      subTitulo: 'Sua pelada agora está na palma da suas mãos! Organize e gerencie suas peladas entre os amigos de forma simples e colaborativa.',
      buttonFirstText: 'Criar nova pelada',
      buttonFirstIcon: LineAwesomeIcons.plus_circle_solid,
      buttonSecoundText: 'Ver minhas peladas',
      buttonSecoundIcon: null,
      buttonFirstAction: () => Get.toNamed('/event/register/event_basic'),
      buttonSecoundAction: () => Get.toNamed('/event/list')
    ),
    //APRENSENTAÇÃO PAGE EXPLORE
    PresentationPageWidget(
      image: AppImages.capaExplore,
      route: 'Explore',
      titulo: 'Encontre o Fut certo para você',
      subTitulo: 'Buscando por um futebol ? Encontrar jogos que estão rolando em tempo real ou que acontecem regularmente no local indicado.',
      buttonFirstIcon: AppIcones.compass_solid,
      buttonFirstText: 'Ver no Mapa',
      buttonSecoundText: 'Pesquisar manualmente',
      buttonSecoundIcon: null,
      buttonFirstAction: () => Get.toNamed('/explore/map'),
      buttonSecoundAction: () => print('navegar para Pesquisa manual'),
    ),
    //APRENSENTAÇÃO PAGE NOTIFICAÇÃO
    const NotificationPage()
  ];
}