import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static ShowcaseController get instance => Get.find();
  //CHAVE DE ENCERRAMETO
  final GlobalKey showcaseStartKey = GlobalKey();
  final GlobalKey showcaseEndKey = GlobalKey();
  //CONTROLLADOR DE SHOWCASE
  final RxSet<String> completedShowcases = <String>{}.obs;
  final RxString currentShowcase = 'start'.obs;
  final RxBool isReady = false.obs;

  //CHAVES DE ELEMENTOS SHOWCASE
  final List<String> elementKeys = [
    'start',
    'navigation',
    'home',
    'menu',
    'chat',
    'profile',
    'escalation',
    'events',
    'explorer',
    'notifications',
    'end',
  ];
  //FUNÇÃO DE MAPEAMENTO DE ELEMENTOS DO SHOWCASE
  Map<String, dynamic> elements = {
    'start': {
      'key': GlobalKey(),
      'title': 'Boas Vindas',
      'description': 'Olá, sejá bem vindo ao Futzada sua plataforma esportiva personalizada. Aqui, você tem tudo o que precisa para aprimorar sua diversão com seus amigos.',
      'subDescription': 'Vamos juntos? Que tal um tuor pela sua nova experiência esportiva?',
      'progress': 0.0,
    },
    'navigation': {
      'key': GlobalKey(),
      'title': 'Barra de Navegação',
      'description': 'Na barra de navegação você pode acessar as principais seções do aplicativo, a pagina de home, escalações, eventos, exploração e notificações.',
      'progress': 0.1,
    },
    'menu': {
      'key': GlobalKey(),
      'title': 'Menu',
      'description': 'No menu você pode acessar as outras funcionalidades do aplicativo como acesso aos amigos, eventos, definição de temas, ajuda e muito mais.',
      'progress': 0.2,
    },
    'chat': {
      'key': GlobalKey(),
      'title': 'Chat',
      'description': 'No chat você pode conversar com seus amigos, individualmente ou em grupos, compartilhar ideias, organizar eventos e manter-se em contato com a comunidade.',
      'progress': 0.3,
    },
    'profile': {
      'key': GlobalKey(),
      'title': 'Perfil',
      'description': 'No perfil você pode visualizar e editar suas informações de usuário, atividades recentes, conquistas, configurações e preferências, dentre outros.',
      'progress': 0.4,
    },
    'home': {
      'key': GlobalKey(),
      'title': 'Home',
      'description': 'Ná Pagina inicial você encontra de tudo, resumos de suas atividades, recomendações, convites, eventos proximos e muito mais.',
      'progress': 0.5,
    },
    'escalation': {
      'key': GlobalKey(),
      'title': 'Escalation',
      'description': 'Na aba de escalação você pode acessar, criar e editar escalações para sua equipe particular com os participantes do eventos que você participa. Lembrando que esse recurso só é habilitado para usuários que atuam como técnico.',
      'progress': 0.6,
    },
    'events': {
      'key': GlobalKey(),
      'title': 'Eventos',
      'description': 'Na aba de eventos você pode conferir os eventos que você participando ou criar novos eventos e convidar os amigos para participar. Gerêncie seus eventos, partidas, participantes e muito mais.',
      'progress': 0.7,
    },
    'explorer': {
      'key': GlobalKey(),
      'title': 'Explorer',
      'description': 'Na aba do explorer você pode descobrir novos eventos pertos de você interagindo com mapas ou com buscas personalizadas. Encontre eventos que se encaixam com seu perfil e participe de novas experiências esportivas.',
      'progress': 0.8,
    },
    'notifications': {
      'key': GlobalKey(),
      'title': 'Notificações',
      'description': 'Na aba de notificações você pode visualizar as notificações recebidas sobre eventos, convites, mensagens e outras atividades relacionadas ao seu perfil e interações dentro do aplicativo.',
      'progress': 0.9,
    },
    'end': {
      'key': GlobalKey(),
      'title': 'É isso!',
      'description': 'Seja bem vindo novamente e aproveite ao máximo sua nova jornada!',
      'progress': 1,
      'action': () => ShowcaseView.get().dismiss(),
    },
  };

  //FUNÇÃO DE CONFIGURAÇÃO DE SHOWCASE
  void setShowCase() {
    //RESGATAR SE USUARIO PASSOU POR ONBORADING (SHOWCASE)
    final tutorial = /* GetStorage().read('tutorial') ??  */false;
    //VERIFICAR SE USUARIO JÁ PASSOU PELO SHOWCASE
    if(!tutorial) {
      //CONFIGURAÇÕES DE SHOWCASE
      ShowcaseView.register(
        blurValue: 0,
        /* disableBarrierInteraction: true, */
        hideFloatingActionWidgetForShowcase: [showcaseEndKey],
        /* globalTooltipActionConfig: const TooltipActionConfig(
          alignment: MainAxisAlignment.spaceBetween,
          actionGap: 20,
        ),
        globalTooltipActions: [
          TooltipActionButton(
            name: 'Anterior',
            type: TooltipDefaultActionType.previous,
            textStyle: const TextStyle(color: AppColors.blue_500),
            hideActionWidgetForShowcase: [elements['start']['key'] as GlobalKey],
            onTap: () => ShowcaseView.getNamed('tutorial').previous(),
          ),
          TooltipActionButton(
            name: 'Pular',
            type: TooltipDefaultActionType.skip,
            textStyle: const TextStyle(color: AppColors.blue_500),
            hideActionWidgetForShowcase: [elements['end']['key'] as GlobalKey],
            onTap: () => ShowcaseView.getNamed('tutorial').dismiss(),
          ),
          TooltipActionButton(
            name: 'Próximo',
            type: TooltipDefaultActionType.next,
            textStyle: const TextStyle(color: AppColors.blue_500),
            hideActionWidgetForShowcase: [elements['end']['key'] as GlobalKey],
            onTap: () => ShowcaseView.getNamed('tutorial').next(force: true),
          ),
        ], */
      );
      // ESPERAR RENDERIZAÇÃO DOS WIDGETS ANTES DE INICIAR SHOWCASE
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isReady.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => startShowcases());
      });
    }
  }

  //FUNÇÃO DE SHOWCASE - INICIAR A PARTIR DO SHOWCASE ATUAL
  void startShowcasesCurrent() => ShowcaseView.get().startShowCase(
    elements.entries
      .skip(elements.keys.toList().indexOf(currentShowcase.value))
      .map((e) => e.value['key'] as GlobalKey)
      .toList()
  );

  //FUNÇÃO DE SHOWCASE - HOME 
  void startShowcases() => ShowcaseView.get().startShowCase(elements.values.map((e) => e['key'] as GlobalKey).toList());
  
  //FUNÇÃO PARA VERIFICAÇÃO DE ETAPA DE SHOWCASE COMPLETO
  bool isShowcaseCompleted(String showcaseId) {
    return completedShowcases.contains(showcaseId);
  }

  //FUNÇÃO PARA COMPLETAR SHOWCASE
  void completeShowcase(String showcaseId) {
    //MARCAR SHOW CASE COMO TRUE
    GetStorage().write('tutorial', true);
    completedShowcases.add(showcaseId);
    ShowcaseView.get().unregister();
    ShowcaseView.get().dismiss();
  }

  //FUNÇÃO PARA REINICIAR SHOWCASES
  void resetShowcases() {
    //MARCAR SHOW CASE COMO TRUE
    GetStorage().write('tutorial', false);
    completedShowcases.clear();
    startShowcases();
  }
}