import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/core/theme/app_images.dart';
import 'package:futzada/presentation/widget/dialogs/dialog_back_home.dart';
import 'package:futzada/presentation/pages/presentation_page.dart';
import 'package:futzada/presentation/pages/home/home_base.dart';
import 'package:futzada/presentation/pages/notification/notification_page.dart';

class NavigationController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static NavigationController get instance => Get.find();
  //ESTADOS - SCAFFOLDKEY, OPTIONS, INDEX, READY
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final RxBool isReady = false.obs;
  final Rx<int> index = 0.obs; 
  final List<Map<String, dynamic>> options = [
    {'label' : "Home", "icon" : Icons.home_filled,},
    {'label' : "Escalação", "icon" : AppIcones.escalacao_outline,},
    {'label' : "Peladas", "icon" : AppIcones.apito},
    {'label' : "Explore", "icon" : Icons.map_rounded,},
    {'label' : "Notificações", "icon" : Icons.notifications,},
  ];

  @override
  void onInit() {
    super.onInit();
    //ADICIONAR KEY DO SCAFFOLD GLOBALMENT AO GET
    Get.put(scaffoldKey, tag: 'appBaseScaffold', permanent: true);
    isReady.value = true;
  }
  
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
    Get.dialog(const DialogBackHome());
  }

  //TELAS DE ESCALAÇÃO
  final screens = [
    //HOME PAGE
    const HomeBase(),
    //APRENSENTAÇÃO PAGE ESCALAÇÕES
    PresentationPageWidget(
      image: AppImages.capaEscalacao,
      route: 'Escalação',
      titulo: 'Monte o sua equipe ideal',
      subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
      buttonFirstText: 'Escalação',
      buttonFirstIcon: AppIcones.clipboard_solid,
      buttonSecoundText: 'Estatisticas',
      buttonSecoundIcon: Icons.add_chart,
      buttonFirstAction: () => Get.toNamed('/escalation'),
      buttonSecoundAction: () => Get.toNamed('/escalation/statistics'),
    ),
    //APRENSENTAÇÃO PAGE PELADAS
    PresentationPageWidget(
      image: AppImages.capaEvent,
      route: 'Peladas',
      titulo: 'Nunca foi tão facil organizar suas peladas',
      subTitulo: 'Sua pelada agora está na palma da suas mãos! Organize e gerencie suas peladas de forma simples e colaborativa.',
      buttonFirstText: 'Criar nova pelada',
      buttonFirstIcon: Icons.add_circle_rounded,
      buttonSecoundText: 'Minhas peladas',
      buttonSecoundIcon: Icons.list_rounded,
      buttonFirstAction: () => Get.toNamed('/event/register/basic'),
      buttonSecoundAction: () => Get.toNamed('/event/list')
    ),
    //APRENSENTAÇÃO PAGE EXPLORE
    PresentationPageWidget(
      image: AppImages.capaExplore,
      route: 'Explore',
      titulo: 'Encontre a pelada certa para você',
      subTitulo: 'Buscando por uma pelada ? Encontre peladas próximas de você ou explore os eventos que ocorrem em sua redondeza.',
      buttonFirstIcon: Icons.map_rounded,
      buttonFirstText: 'Ver no Mapa',
      buttonSecoundText: 'Pesquisar',
      buttonSecoundIcon: Icons.manage_search_rounded,
      buttonFirstAction: () => Get.toNamed('/explore/map'),
      buttonSecoundAction: () => Get.toNamed('/explore/search'),
    ),
    //APRENSENTAÇÃO PAGE NOTIFICAÇÃO
    const NotificationPage()
  ];
}