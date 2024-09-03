import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_images.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:futzada/pages/apresentacao_page.dart';
import 'package:futzada/pages/home/home_page.dart';

class NavigationController extends GetxController {
  //SCAFFOLD KEY
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
    ApresentacaoPageWiget(
      image: AppImages.capaEscalacao,
      route: 'Escalação',
      titulo: 'Monte o seu time ideal da pelada',
      subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
      buttonTitulo: 'Começar Escalar',
      buttonIcone: AppIcones.clipboard_solid,
      viewTitulo: 'Ver minhas escalações',
      buttonAction: () => Get.toNamed('/escalacao'),
      outlineAction: () => print('navegar para Minhas escalações'),
    ),
    //APRENSENTAÇÃO PAGE PELADAS
    ApresentacaoPageWiget(
      image: AppImages.capaPelada,
      route: 'Peladas',
      titulo: 'Nunca foi tão facil organizar suas peladas',
      subTitulo: 'Sua pelada agora está na palma da suas mãos! Organize e gerencie suas peladas entre os amigos de forma simples e colaborativa.',
      buttonTitulo: 'Criar nova pelada',
      buttonIcone: LineAwesomeIcons.plus_circle_solid,
      viewTitulo: 'Ver minhas peladas',
      buttonAction: () => Get.toNamed('/pelada/cadastro/dados_pelada'),
      outlineAction: () => print('navegar para Minhas peladas'),
    ),
    //APRENSENTAÇÃO PAGE EXPLORE
    ApresentacaoPageWiget(
      image: AppImages.capaExplore,
      route: 'Explore',
      titulo: 'Encontre o Fut certo para você',
      subTitulo: 'Buscando por um futebol ? Encontrar jogos que estão rolando em tempo real ou que acontecem regularmente no local indicado.',
      buttonIcone: AppIcones.compass_solid,
      buttonTitulo: 'Ver no Mapa',
      viewTitulo: 'Pesquisar manualmente',
      buttonAction: () => print('navegar para Explore no mapa'),
      outlineAction: () => print('navegar para Pesquisa manual'),
    ),
    //APRENSENTAÇÃO PAGE NOTIFICAÇÃO
    ApresentacaoPageWiget(
      image: AppImages.capaEscalacao,
      route: 'Notificações',
      titulo: 'Monte o seu time ideal da pelada',
      subTitulo: 'Escale os melhores jogadores da pelada para sua equipe e fique no topo dos rankings da pelada.',
      buttonTitulo: 'Começar Escalar',
      buttonIcone: AppIcones.clipboard_solid,
      viewTitulo: 'Ver minhas escalações',
      buttonAction: () => print('navegar para Notificações'),
      outlineAction: () => print('navegar para Notificações'),
    ),
  ];
}