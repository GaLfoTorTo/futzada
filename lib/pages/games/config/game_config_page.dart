import 'package:flutter/material.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/game_controller.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/pages/games/config/game_config_basic_page.dart';
import 'package:futzada/pages/games/config/game_config_teams_page.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/dialogs/game_config_dialog.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:get/get.dart';

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
  //DEFINIR CONTROLADOR DE PAGINAS DE CONFIGURAÇÃO
  PageController _pageController = PageController();
  //CONTROLADOR DE INDEX DO STEP
  int currentPage = 0;
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    void stepForm(String step){
      //VERIFICAR BOTÃO CLICADO
      if (step == 'continue') {
        if (currentPage < 1) {
          setState(() {
            currentPage += 1;
          });
          _pageController.animateToPage(
            currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }else{
          //EXIBIR MODAL DE CONFIRMAÇÃO
          Get.dialog(GameConfigDialog(
            event: gameController.event!,
            game: game,
          ));
        }
      } else {
        if (currentPage > 0) {
          setState(() {
            currentPage -= 1;
          });
          _pageController.animateToPage(
            currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      }
    }
    
    return Scaffold(
      appBar: HeaderWidget(
        title: "Partida #${game.number}",
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: currentPage == 0 ? dimensions.height : dimensions.height + (gameController.event!.qtdPlayers! * 40),
            ),
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
                          "Defina os parametros iniciais para o inicio da partida. Você pode reaproveitar as configurações para as próximas partidas.",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.blue_500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      GameConfigBasicPage(
                        game: game
                      ),
                      GameConfigTeamsPage(
                        game: game
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonOutlineWidget(
                        text: "Voltar",
                        width: 100,
                        action: () => stepForm('voltar')
                      ),
                      ButtonTextWidget(
                        text: currentPage == 0 ? "Continuar" : "Iniciar",
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
      )
    );
  }
}