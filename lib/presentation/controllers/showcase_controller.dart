import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/storage/app_storage.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETIT
  static ShowcaseController get instance => sl<ShowcaseController>();
  //CHAVE DE ENCERRAMETO
  final GlobalKey showcaseStartKey = GlobalKey();
  final GlobalKey showcaseEndKey = GlobalKey();

  //CONTROLLADOR DE SHOWCASE
  String _currentShowcase = 'start';
  String get currentShowcase => _currentShowcase;
  set currentShowcase(String v) { _currentShowcase = v; notifyListeners(); }

  bool _isReady = false;
  bool get isReady => _isReady;
  set isReady(bool v) { _isReady = v; notifyListeners(); }

  bool _isCompleted = false;
  bool get isCompleted => _isCompleted;
  set isCompleted(bool v) { _isCompleted = v; notifyListeners(); }

  //CHAVES DE ELEMENTOS SHOWCASE
  final List<String> elementKeys = [
    'start',
    'navigation',
    'menu',
    'chat',
    'profile',
    'home',
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
      'description': 'No chat você pode conversar com seus amigos individualmente ou em grupos, compartilhar ideias, organizar eventos e manter-se em contato com a comunidade.',
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
      'description': 'Na aba de escalação você pode acessar, criar e editar escalações para sua equipe particular com os participantes dos eventos que você esta participando participa.',
      'progress': 0.6,
    },
    'events': {
      'key': GlobalKey(),
      'title': 'Eventos',
      'description': 'Na aba de eventos você pode conferir os eventos que você esta participando ou criar novos eventos para se divertir com seus amigos podendo gerenciar partidas, rankings e muito mais.',
      'progress': 0.7,
    },
    'explorer': {
      'key': GlobalKey(),
      'title': 'Explorer',
      'description': 'Na aba do explorer você pode descobrir novos eventos em sua região interagindo com mapas ou com buscas personalizadas. Encontre eventos que se encaixam com seu perfil e participe de novas experiências esportivas.',
      'progress': 0.8,
    },
    'notifications': {
      'key': GlobalKey(),
      'title': 'Notificações',
      'description': 'Na aba de notificações você pode visualizar as notificações recebidas sobre eventos, convites, mensagens, interações e outras atividades relacionadas ao seu perfil.',
      'progress': 0.9,
    },
    'end': {
      'key': GlobalKey(),
      'title': 'Eai ? preparado para começar!',
      'description': 'Seja bem vindo novamente e aproveite ao máximo sua nova jornada!',
      'subDescription': 'Complete as tarefas de cadastro para finalize seu perfil de usuário.',
      'progress': 1.0,
    },
  };

  //FUNÇÃO DE DEFINIÇÃO DE INDEX (NAVBAR)
  int setIndexNavigation() {
    switch (currentShowcase) {
      case 'escalation':
        return 1;
      case 'events':
        return 2;
      case 'explorer':
        return 3;
      case 'notifications':
        return 4;
      default:
        return 0;
    }
  }

  //FUNÇÃO DE CONFIGURAÇÃO DE SHOWCASE
  void setShowcase() {
    //RESGATAR SE USUARIO PASSOU POR ONBORADING (SHOWCASE)
    final tutorial = AppStorage.read<bool>('tutorial') ?? false;
    //VERIFICAR SE USUARIO JÁ PASSOU PELO SHOWCASE
    if (!tutorial) {
      //CONFIGURAÇÕES DE SHOWCASE
      ShowcaseView.register(
        blurValue: 0,
        hideFloatingActionWidgetForShowcase: [showcaseEndKey],
        onComplete: (showcaseIndex, key) => completeShowcase(),
      );
      //ESPERAR RENDERIZAÇÃO DOS WIDGETS ANTES DE INICIAR SHOWCASE
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isReady = true;
        WidgetsBinding.instance.addPostFrameCallback((_) => startShowcase());
      });
    }
  }

  //FUNÇÃO DE SHOWCASE - HOME
  void startShowcase() {
    //INICIALIZAR SHOWCASE
    ShowcaseView.get().startShowCase(
      elements.values
        .map((e) => e['key'] as GlobalKey)
        .toList()
    );
  }

  //FUNÇÃO PARA COMPLETAR SHOWCASE
  void completeShowcase() {
    isCompleted = true;
    //MARCAR SHOW CASE COMO TRUE
    AppStorage.write('tutorial', true);
    ShowcaseView.get().unregister();
    ShowcaseView.get().dismiss();
  }

  //FUNÇÃO PARA REINICIAR SHOWCASES
  void resetShowcase() {
    //MARCAR SHOW CASE COMO TRUE
    AppStorage.write('tutorial', false);
    startShowcase();
  }
}
