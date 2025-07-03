import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/widget/inputs/silder_players_widget.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/indicators/indicator_form_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/controllers/navigation_controller.dart';
import 'package:futzada/controllers/event_controller.dart';

class EventConfigGameStep extends StatefulWidget {  
  const EventConfigGameStep({super.key});

  @override
  State<EventConfigGameStep> createState() => EventConfigGameStepState();
}

class EventConfigGameStepState extends State<EventConfigGameStep> {
  //RESGATAR CONTROLLER DE NAVEGAÇÃO
  NavigationController navigationController = NavigationController.instance;
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //DEFINIR FORMKEY
  final formKey = GlobalKey<FormState>();
  //DEFINIR VARIAVEIS DE CONTROLLE DE SLIDER
  int qtdPlayers = 11;
  int minPlayers = 9;
  int maxPlayers = 11;
  int divisions = 3;

  @override
  void initState() {
    super.initState();
  }

  //FUNÇÃO PARA RESGATAR ICONE DA CATEGORIA
  IconData getIconCategory(key){
    switch (key) {
      case "Futebol":
        return AppIcones.foot_futebol_solid;
      case "Fut7":
        return AppIcones.foot_fut7_solid;
      case "Futsal":
        return AppIcones.foot_futsal_solid;
      default:
        return AppIcones.foot_futebol_solid;
    }
  }

  //FUNÇÃO PARA VALIDAR FORMULÁRIO
  bool validForm(){
    //RESGATAR O FORMULÁRIO
    var formData = formKey.currentState;
    //VERIFIAR SE CAMPOS DE TEXTO FORAM PREENCHIDOS
    if(formData?.validate() ?? false){
      //VERIFICAR SE VISIBILIDADE FOI SELECIONADA
      if(eventController.visibilityController.text.isNotEmpty){
        return true;
      }
    }
    return false;
  }

  //VALIDAÇÃO DA ETAPA
  void submitForm(){
    //VERIFICAR SE DADOS DA ETAPA FORAM PREENCHIDOS CORRETAMENTE
    if (validForm()) {
      //NAVEGAR PARA CADASTRO DE ENDEREÇO
      Get.toNamed('/event/register/address');
    }
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Registro", 
        leftAction: () => Get.back(),
        rightAction: () => navigationController.backHome(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              width: dimensions.width,
              padding: const EdgeInsets.all(15),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const IndicatorFormWidget(
                    length: 3,
                    etapa: 0
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Configuração de partidas",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Certo, vamos lá! Informe o Nome, a Bio e defina uma Imagem para capa da sua pelada. Você também pode definir as configurações de visibilidade e se sua pelada contará com colaboradores.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child:Text(
                      "Categoria",
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...eventController.categories.entries.map((item){
                          final key = item.key;
                          final value = item.value;
                          //RESGATAR ICONE DA CATEGORIA
                          IconData icone = getIconCategory(key);
                          return SelectRoundedWidget(
                            value: value,
                            icon: icone,
                            size: 120,
                            iconSize: 40,
                            checked: value == eventController.categoryController.text,
                            onChanged: (value) {
                              setState(() {
                                eventController.categoryController.text = value;
                              });
                            },
                          );
                        })
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child:Text(
                          "Quantidade de Jogadores",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Defina quantos jogadores atuaram em campo por cada equipe. Essa informação podera ser alterada a qualquer momento após o registro.",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.gray_500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SilderPlayersWidget(
                        qtdPlayers: qtdPlayers.toDouble(),
                        minPlayers: minPlayers.toDouble(),
                        maxPlayers: maxPlayers.toDouble(),
                        divisions: divisions,
                        onChange: (value){
                          setState(() {
                            eventController.playersPerTeamController.text = qtdPlayers.toString();
                          });
                        },
                      ),
                      /* CampoWidget(
                        categoria: eventController.categoryeventController.text,
                        qtd: eventController.qtdPlayers,
                      ), */
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ButtonTextWidget(
                      text: "Próximo",
                      width: double.infinity,
                      action: submitForm
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}