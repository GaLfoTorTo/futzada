import 'package:flutter/material.dart';
import 'package:futzada/pages/apresentacao_page.dart';
import 'package:futzada/pages/home/home_page.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class NavigationController extends GetxController {
  //SCAFFOLD KEY
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //CONTROLADOR DE INDEX NAVIGATION BAR
  final Rx<int> index = 0.obs; 
  //CONTROLLER DE NAVEGAÇÃO DE HOME
  final homeController = Get.put(HomeNavigationController());
  //CONTROLLER DE NAVEGAÇÃO DE ESCALAÇÃO
  final escalacaoController = Get.put(EscalacaoNavigationController());
  //CONTROLLER DE NAVEGAÇÃO DE PELADA
  final peladaController = Get.put(PeladaNavigationController());
  //CONTROLLER DE NAVEGAÇÃO DE ESCALAÇÃO
  final exploreController = Get.put(ExploreNavigationController());
  //CONTROLLER DE NAVEGAÇÃO DE ESCALAÇÃO
  final notificacaoController = Get.put(NotificacaoNavigationController());
}

class BaseNavigationController extends GetxController {
  //CHAVE DE NAVEGAÇÃO DE ESCALAÇÃO
  final navigatorKey = GlobalKey<NavigatorState>();
  //CONTROLADOR DE INDEX NAVIGATION ESCALAÇÃO
  final Rx<int> index = 0.obs; 
  //TELAS DE ESCALAÇÃO
  late final List<Widget> screens;
  //FUNÇÃO DE ATUALIZAÇÃO DE INDEX
  void updateIndex(int newIndex) {
    index.value = newIndex;
  }
}

class HomeNavigationController extends BaseNavigationController {
  //CHAVE DE NAVEGAÇÃO DE HOME
  final navigatorKey = GlobalKey<NavigatorState>();
  //CONTROLADOR DE INDEX NAVIGATION HOME
  final Rx<int> index = 0.obs; 
  //TELAS DE HOME
  final screens = [
    //HOME PAGE
    const HomePage(),
  ];
}

class EscalacaoNavigationController extends BaseNavigationController {
  //CHAVE DE NAVEGAÇÃO DE ESCALAÇÃO
  final navigatorKey = GlobalKey<NavigatorState>();
  //CONTROLADOR DE INDEX NAVIGATION ESCALAÇÃO
  final Rx<int> index = 0.obs; 
  //TELAS DE ESCALAÇÃO
  final screens = [
    //APRENSENTAÇÃO PAGE ESCALAÇÃO
    ApresentacaoPageWiget(
      image: AppImages.capaEscalacao,
      route: 'Escalação',
      titulo: 'Monte o seu time ideal da pelada',
      subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
      buttonTitulo: 'Começar Escalar',
      buttonIcone: AppIcones.clipboard_solid,
      viewTitulo: 'Ver minhas escalações',
      createAction: () => {},
      viewAction: () => {},
    ),
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
    Container(color: Colors.yellow)
  ];
}

class PeladaNavigationController extends BaseNavigationController {
  //CHAVE DE NAVEGAÇÃO DE ESCALAÇÃO
  final navigatorKey = GlobalKey<NavigatorState>();
  //CONTROLADOR DE INDEX NAVIGATION ESCALAÇÃO
  final Rx<int> index = 0.obs; 

  //TELAS DE ESCALAÇÃO
  final screens = [
    //APRENSENTAÇÃO PAGE PELADA
    ApresentacaoPageWiget(
      image: AppImages.capaPelada,
      route: 'Peladas',
      titulo: 'Nunca foi tão facil organizar suas peladas',
      subTitulo: 'Sua pelada agora está na palma da suas mãos! Organize e gerencie suas peladas entre os amigos de forma simples e colaborativa.',
      buttonTitulo: 'Criar nova pelada',
      buttonIcone: LineAwesomeIcons.plus_circle_solid,
      viewTitulo: 'Ver minhas peladas',
      createAction: () => {},
      viewAction: () => {},
    ),
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.yellow)
  ];
}

class ExploreNavigationController extends BaseNavigationController {
  //CHAVE DE NAVEGAÇÃO DE ESCALAÇÃO
  final navigatorKey = GlobalKey<NavigatorState>();
  //CONTROLADOR DE INDEX NAVIGATION ESCALAÇÃO
  final Rx<int> index = 0.obs; 

  //TELAS DE ESCALAÇÃO
  final screens = [
    //APRENSENTAÇÃO PAGE EXPLORE
    ApresentacaoPageWiget(
      image: AppImages.capaExplore,
      route: 'Explore',
      titulo: 'Encontre o Fut certo para você',
      subTitulo: 'Buscando por um futebol ? Encontrar jogos que estão rolando em tempo real ou que acontecem regularmente no local indicado.',
      buttonIcone: AppIcones.compass_solid,
      buttonTitulo: 'Ver no Mapa',
      viewTitulo: 'Pesquisar manualmente',
      createAction: () => {},
      viewAction: () => {},
    ),
    Container(color: Colors.yellow),
    Container(color: Colors.red),
    Container(color: Colors.green),
  ];
}

class NotificacaoNavigationController extends BaseNavigationController {
  //CHAVE DE NAVEGAÇÃO DE ESCALAÇÃO
  final navigatorKey = GlobalKey<NavigatorState>();
  //CONTROLADOR DE INDEX NAVIGATION ESCALAÇÃO
  final Rx<int> index = 0.obs; 

  //TELAS DE ESCALAÇÃO
  final screens = [
    //APRENSENTAÇÃO PAGE NOTIFICAÇÃO
    ApresentacaoPageWiget(
      image: AppImages.capaEscalacao,
      route: 'Notificações',
      titulo: 'Monte o seu time ideal da pelada',
      subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
      buttonTitulo: 'Começar Escalar',
      buttonIcone: AppIcones.clipboard_solid,
      viewTitulo: 'Ver minhas escalações',
      createAction: () => {},
      viewAction: () => {},
    ),
    Container(color: Colors.yellow),
    Container(color: Colors.red),
    Container(color: Colors.green),
  ];
}