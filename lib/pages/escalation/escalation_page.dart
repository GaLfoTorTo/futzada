import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_widget.dart';
import 'package:futzada/widget/buttons/button_formation_widget.dart';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
import 'package:futzada/widget/cards/card_escalation_list_widget.dart';
import 'package:futzada/widget/others/campo_widget.dart';
import 'package:futzada/widget/others/reserve_bank_widget.dart';
import 'package:futzada/widget/text/price_indicator_widget.dart';

class EscalationPage extends StatefulWidget {  
  const EscalationPage({
    super.key,
  });

  @override
  State<EscalationPage> createState() => EscalationPageState();
}

class EscalationPageState extends State<EscalationPage> {
  bool formationButton = true;
  bool listButton = false;
  String viewType = 'escalation';
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instace;

  //FUNÇÃO PARA SELECIONAR EVENTO
  void selectEvent(newValue){
    setState(() {
      controller.selectedEvent = newValue;
      controller.update();
    });
  }
  //FUNÇÃO PARA SELECIONAR TIPO DE VISUALIZAÇÃO
  void selectView(type){
    setState(() {
      //VERIFICAR O TIPO RECEBIDO
      viewType = type;
    });
  }
  //FUNÇÃO PARA SELECIONAR FORMAÇÃO
  void selectFormation(newValue){
    setState(() {
      controller.selectedFormation = newValue;
      controller.update();
    });
  }
  //FUNÇÃO DE NOMECLATURA DE POSIÇÕES
  String setNamePositionFormation(int i, String type){
    if(type == 'starters'){
      switch (i) {
        case 0:
          return 'Goleiro';
        case 1:
        case 2:
          return 'Zagueiro';
        case 3:
        case 4:
          return 'Lateral';
        case 5:
        case 6:
        case 7:
          return 'Meio-Campo';
        case 8:
        case 9:
        case 10:
          return 'Atacante';
        default:
          return 'Jogador';
      }
    }else{
      switch (i) {
        case 0:
          return 'Goleiro';
        case 1:
          return 'Zagueiro';
        case 2:
          return 'Lateral';
        case 3:
          return 'Meio-Campo';
        case 4:
          return 'Atacante';
        default:
          return 'Jogador';
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR ESCALAÇÃO TITULAR
    var escalationStarters = controller.escalation['starters'];
    //RESGATAR ESCALAÇÃO RESERVAS
    var escalationReserves = controller.escalation['reserves'];

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Escalação',
        leftAction: () => Get.back(),
        rightAction: () => Get.toNamed('/escalation/market'),
        rightIcon: Icons.shopping_cart,
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: dimensions.width,
                height: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark_500.withAlpha(30),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: Offset(2, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: (dimensions.width / 3) - 10,
                      child: ButtonDropdownWidget(
                        selectedEvent: controller.selectedEvent,
                        itens: controller.myEvents,
                        onChange: selectEvent,
                        iconAfter: false,
                      ),
                    ),
                    Container(
                      width: (dimensions.width / 3) - 10,
                      child: PriceIndicatorWidget(
                        title: 'Preço da Equipe',
                        value: '103.07'
                      ),
                    ),
                    Container(
                      width: (dimensions.width / 3) - 10,
                      child: PriceIndicatorWidget(
                        title: 'FutCoins',
                        value: '0.25'
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      width: ( dimensions.width / 2 ) -10,
                      child: ButtonFormationWidget(
                        selectedFormation: controller.selectedFormation, 
                        onChange: selectFormation
                      ),
                    ),
                    Container(
                      width: ( dimensions.width / 2 ) -10 ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ButtonIconWidget(
                              icon: AppIcones.escalacao_outline, 
                              iconColor: viewType == 'escalation' ? AppColors.white : AppColors.gray_500,
                              color: viewType == 'escalation' ? AppColors.green_300 : AppColors.white,
                              width: 60,
                              height: 60,
                              action: () => selectView('escalation')
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ButtonIconWidget(
                              icon: AppIcones.clipboard_outline, 
                              iconColor: viewType == 'list' ? AppColors.white : AppColors.gray_500,
                              color: viewType == 'list' ? AppColors.green_300 : AppColors.white,
                              width: 60,
                              height: 60,
                              action: () => selectView('list')
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
              //VERIFICAR TIPO DE VISUALIZAÇÃO (ESCALAÇÃO OU LISTA)
              if(viewType == 'escalation')...[
                CampoWidget(
                  categoria: 'Campo',
                  width: ( dimensions.width ) - 80,
                  height: ( dimensions.height / 2) + 50,
                  formation: controller.selectedFormation,
                ),
              ]else...[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Titulares',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                ...escalationStarters!.entries.map((entry) {
                  //RESGATAR ITENS 
                  int key = entry.key;
                  //RESGATAR O NOME DA POSIÇÃO DE ACORDO COM O INDEX DE RENDERIZAÇÃO
                  String namePosition = setNamePositionFormation(key, 'starters');
                  //RESGATAR ITENS 
                  final item = entry.value;
                  return  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: CardEscalationListWidget(
                      player: item,
                      namePosition: namePosition
                    ),
                  );
                }).toList(),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Text(
                  'Banco de Reservas',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              //VERIFICAR TIPO DE VISUALIZAÇÃO PARA BANCO DE RESERVAS (ESCALAÇÃO OU LISTA)
              if(viewType == 'escalation')...[
                ReserveBankWidget(
                  category: controller.category,
                )
              ]else...[
                ...escalationReserves!.entries.map((entry) {
                  //RESGATAR ITENS 
                  int key = entry.key;
                  //RESGATAR O NOME DA POSIÇÃO DE ACORDO COM O INDEX DE RENDERIZAÇÃO
                  String namePosition = setNamePositionFormation(key, 'reserves');
                  //RESGATAR ITENS 
                  final item = entry.value;
                  return  CardEscalationListWidget(
                    player: item,
                    namePosition: namePosition,
                  );
                }).toList(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}