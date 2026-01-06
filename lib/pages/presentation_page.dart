import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_outline_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/dialogs/dialog_erro_escalation.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/controllers/navigation_controller.dart';

class PresentationPageWidget extends StatelessWidget {
  final String image;
  final String route;
  final String titulo;
  final String subTitulo;
  final String buttonFirstText;
  final IconData? buttonFirstIcon;
  final String buttonSecoundText;
  final IconData? buttonSecoundIcon;
  final VoidCallback buttonFirstAction;
  final VoidCallback buttonSecoundAction;

  const PresentationPageWidget({
    super.key,
    required this.image,
    required this.route,
    required this.titulo,
    required this.subTitulo,
    required this.buttonFirstText,
    this.buttonFirstIcon,
    required this.buttonSecoundText, 
    this.buttonSecoundIcon, 
    required this.buttonFirstAction, 
    required this.buttonSecoundAction, 
  });

  @override
  Widget build(BuildContext context) {
    //INICIALIZAR CONTROLLER DE NAVEGACAO E DE ESCALAÇÃO
    NavigationController navigationController = NavigationController.instance;
    EscalationController escalationController = EscalationController.instance;

    //DEFINIR VARAIVEL DE VERIFICAÇÃO DE USUARIO
    bool canManager = true;
    
    //FUNÇÃO DE MENSAGEM DE ERRO CASO O USUARIO NÃO POSSA ACESSAR 
    void firstAction(){
      //VERIIFCAR SE EXISTE ALGUM IMPEDITIVO DE AVANÇO DO USUARIO
      if(canManager){
        buttonFirstAction();
      }else{
        //EXIBIR DIALOG DE ERRO
        Get.dialog(const DialogErrorEscalation());
      }
    }

    //VERIFICAR ROTA PARA INICIALIZAÇÃO DE CONTROLLER
    switch (route) {
      case 'Peladas':
        
        break;
      case 'Escalação':
        canManager = escalationController.canManager;
        break;
      case 'Explore':
        break;
      case 'Notificações':
        break;
      default:
    }
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //DEFINIR COR APARTIR DO TEMA
    final colorPage = Get.isDarkMode ? AppColors.dark_500 : AppColors.white;

    return Scaffold(
      appBar: HeaderWidget(
        title: route,
        leftAction: () => navigationController.directIndex(0),
      ),
      backgroundColor: colorPage,
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: dimensions.width,
            child: Column(
              children: [
                Container(
                  height: (dimensions.height / 3) - 20,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        colorPage, 
                        BlendMode.saturation
                      )
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colorPage.withAlpha(100),
                          colorPage,
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
                          style: Theme.of(context).textTheme.headlineLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          subTitulo,
                          style: Theme.of(context).textTheme.titleSmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Column(
                        children: [
                          ButtonTextWidget(
                            text: buttonFirstText,
                            width: dimensions.width,
                            icon: buttonFirstIcon,
                            action: firstAction,
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          ButtonOutlineWidget(
                            text: buttonSecoundText,
                            width: dimensions.width,
                            icon: buttonSecoundIcon,
                            action: buttonSecoundAction,
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