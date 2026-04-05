import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/buttons/button_text_widget.dart';
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
  RxBool isReady = false.obs;

  //FUNÇÃO DE MAPEAMENTO DE ELEMENTOS DO SHOWCASE
  Map<String, dynamic> elements = {
    'start': {
      'key': GlobalKey(),
      'title': 'Boas Vindas',
      'description': 'Olá, sejá bem vindo ao Futzada sua plataforma esportiva personalizada. Aqui, você tem tudo o que precisa para aprimorar sua diversão com seus amigos.',
      'subDescription': 'Vamos juntos? Que tal um tuor pela sua nova experiência esportiva?',
      'progress': 0.1,
    },
    'navigation': {
      'key': GlobalKey(),
      'title': 'Barra de Navigação',
      'description': 'Na barra de navegação você pode acessar as principais seções do aplicativo, a pagina de home, escalações, eventos, exploração e notificações.',
      'progress': 0.2,
    },
    'home': {
      'key': GlobalKey(),
      'title': 'Home',
      'description': 'Ná Pagina inicial você encontra de tudo, resumos de suas atividades, recomendações, convites, eventos proximos e muito mais.',
      'progress': 0.3,
    },
    'end': {
      'key': GlobalKey(),
      'title': 'É isso!',
      'description': 'Seja bem vindo novamente e aproveite o máximo sua nova jornada.',
      'progress': 1,
    },
  };
  
  //FUNÇÃO DE CONFIGURAÇÃO DE SHOWCASE
  void setShowCase() {
    //RESGATAR SE USUARIO PASSOU POR ONBORADING (SHOWCASE)
    final tutorial = GetStorage().read('tutorial') ?? false;
    //VERIFICAR SE USUARIO JÁ PASSOU PELO SHOWCASE
    if(!tutorial) {
      //CONFIGURAÇÕES DE SHOWCASE
      ShowcaseView.register(
        blurValue: 1,
        enableAutoScroll: true,
        hideFloatingActionWidgetForShowcase: [showcaseEndKey],
        globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
          left: 16,
          bottom: 25,
          child: ButtonTextWidget(
            text: 'Pular',
            height: 20,
            action: () => ShowcaseView.get().dismiss(),
          ),
        ),
        globalTooltipActionConfig: const TooltipActionConfig(
          position: TooltipActionPosition.inside,
          alignment: MainAxisAlignment.spaceBetween,
          actionGap: 20,
        ),
        globalTooltipActions: [
          //ESCONDER TOOTIP BUTTON PARA PRIMEIRA AÇÃO
          TooltipActionButton(
            name: 'Anterior',
            type: TooltipDefaultActionType.previous,
            textStyle: const TextStyle(color: AppColors.blue_500),
            hideActionWidgetForShowcase: [elements['start']['key'] as GlobalKey],
          ),
          //ESCONDER TOOTIP BUTTON PARA ULTIMA AÇÃO
          TooltipActionButton(
            name: 'Próximo',
            type: TooltipDefaultActionType.next,
            textStyle: const TextStyle(color: AppColors.blue_500),
            hideActionWidgetForShowcase: [elements['end']['key'] as GlobalKey],
            onTap: () => print('Próximo Pressionado')
          ),
        ],
        onDismiss: (key) {
          completeShowcase(key.toString());
        },
      );
      // ESPERAR RENDERIZAÇÃO DOS WIDGETS ANTES DE INICIAR SHOWCASE
      WidgetsBinding.instance.addPostFrameCallback((_) {
        isReady.value = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          startShowcases();
        });
      });
    }
  }

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