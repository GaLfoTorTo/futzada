import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';

class PresentationPageWidget extends StatelessWidget {
  final String image;
  final String route;
  final String titulo;
  final String subTitulo;
  final String buttonTitulo;
  final IconData buttonIcone;
  final String viewTitulo;
  final VoidCallback buttonAction;
  final VoidCallback outlineAction;

  const PresentationPageWidget({
    super.key,
    required this.image,
    required this.route,
    required this.titulo,
    required this.subTitulo,
    required this.buttonTitulo,
    required this.buttonIcone,
    required this.viewTitulo, 
    required this.buttonAction, 
    required this.outlineAction, 
  });

  @override
  Widget build(BuildContext context) {
    //RESGATAR CONTROLLERDE NAVEGACAO DE TABS
    final navigationTab = Get.find<NavigationController>();
    //VERIFICAR ROTA PARA INICIALIZAÇÃO DE CONTROLLER
    switch (route) {
      case 'Peladas':
        //INICIALIZAR CONTROLLER DE EVENTO
        Get.put(EventController());
        break;
      case 'Escalação':
        //INICIALIZAR CONTROLLER DE ESCALÇAO
        Get.put(EscalationController());
        break;
      case 'Explore':
        //INICIALIZAR CONTROLLER DE EXPLORER
        Get.put(EventController());
        break;
      case 'Notificações':
        //INICIALIZAR CONTROLLER DE NOTIFICAÇÕES
        Get.put(EventController());
        break;
      default:
    }
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: route,
        leftAction: () => navigationTab.directIndex(0),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: dimensions.width,
            color: AppColors.white,
            child: Column(
              children: [
                Container(
                  height: (dimensions.height / 3) - 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.white.withOpacity(0.5),
                          AppColors.white,
                        ],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: dimensions.height / 2,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          titulo,
                          style: const TextStyle(
                            color: AppColors.blue_500,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          subTitulo,
                          style: const TextStyle(
                            color: AppColors.blue_500,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        children: [
                          ButtonTextWidget(
                            text: buttonTitulo,
                            width: dimensions.width,
                            icon: buttonIcone,
                            action: buttonAction,
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          ButtonOutlineWidget(
                            text: viewTitulo,
                            width: dimensions.width,
                            action: outlineAction,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}