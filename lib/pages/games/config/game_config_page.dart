import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/dialogs/game_config_dialog.dart';
import 'package:futzada/pages/games/config/game_config_basic_page.dart';
import 'package:futzada/pages/games/config/game_config_teams_page.dart';

class GameConfigPage extends StatefulWidget {
  final GameModel? game;
  const GameConfigPage({
    super.key,
    this.game
  });

  @override
  State<GameConfigPage> createState() => _GameConfigPageState();
}

class _GameConfigPageState extends State<GameConfigPage> {
  //RESHATAR CONTROLLER DE PARTIDA
  GameController gameController = GameController.instance;
  //RESGATAR PARTIDA
  GameModel game = Get.arguments['game'];
  //CONTROLADOR DE INDEX DO STEP
  int currentPage = Get.arguments['index'] ?? 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ADICIONAR PARTIDA RECEBIDA POR ARGUMENTO COMO JOGO ATUAL NO CONTROLLER
    gameController.currentGame = game;
    //INICIARLIZAR CONTROLLERS DE TEXTO
    gameController.initTextControllers();
  }

  //FUNÇÃO PARA PROSSEGUIR OU RETROCEDER NAS CONFIGURAÇÕES
  void stepForm(String step){
    //VERIFICAR BOTÃO CLICADO
    if (step == 'continue') {
      if (currentPage < 1) {
        setState(() {
          currentPage += 1;
        });
      }else{
        //VERIIFCAR SE EQUIPES FORAM MONTADAS
        if(
          gameController.teamA.players.length == gameController.currentGameConfig!.playersPerTeam && 
          gameController.teamA.players.length == gameController.currentGameConfig!.playersPerTeam
        ){
          //VERIFICAR SE EVENTO JA TEM CONFIGURAÇÕES SALVAS
          if(gameController.event.gameConfig == null){
            //EXIBIR MODAL DE CONFIRMAÇÃO
            Get.dialog(GameConfigDialog(
              event: gameController.event,
              game: game,
            ));
          }else{
            //DEFINIR PARTIDA ATUAL
            gameController.setGame();
            //NAVEGAR PARA PAGINA DE DETALHES DO JOGO
            Get.offNamed('/games/overview', arguments: {
              'game': game,
              'event': gameController.event,
            });
          }
        }else{
          AppHelper.feedbackMessage(context, "Os times não tem jogadores suficientes para continuar");
        }
      }
    } else {
      if (currentPage > 0) {
        setState(() {
          currentPage -= 1;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: HeaderWidget(
        title: "Partida #${game.number}",
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: AppColors.green_300,
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Configurações da Partida",
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppColors.blue_500
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          "Defina os parâmetros da partida que deseja iniciar. Você pode salvar as configurações para reutilizá-las nas próximas partidas.",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.blue_500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                if(currentPage == 0)...[
                  const GameConfigBasicPage(),
                ]else ...[
                  const GameConfigTeamsPage(),
                ],
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonOutlineWidget(
                        text: "Voltar",
                        width: 100,
                        action: () => currentPage == 0 ? Get.back() : stepForm('voltar')
                      ),
                      ButtonTextWidget(
                        text: "Continuar",
                        icon: currentPage == 1 ? AppIcones.apito : null,
                        width: 100,
                        action: () => stepForm('continue')
                      ),
                    ],
                  ),
                )
              ]
            ),
          ),
        ),
    );
  }
}