import 'package:futzada/widget/buttons/float_button_escalation_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/text/price_indicator_widget.dart';
import 'package:futzada/widget/lists/escalation_list_widget.dart';
import 'package:futzada/widget/others/escalation_widget.dart';
import 'package:futzada/widget/others/reserve_bank_widget.dart';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_icon_widget.dart';
import 'package:futzada/widget/buttons/button_formation_widget.dart';

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
  EscalationController escalationController = EscalationController.instance;

  //FUNÇÃO PARA SELECIONAR EVENTO
  void selectEvent(id){
    setState(() {
      //SELECIONAR EVENTO
      escalationController.setEvent(id);
      //ATUALIZAR CONTROLLER
      escalationController.update();
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
      escalationController.selectedFormation.value = newValue;
      escalationController.update();
    });
  }
  
  //FUNÇÃO PARA DEFINIR FILTROS QUANDO NEVEGAÇÃO FOR DIRETO PARA MERCADO
  void goToMarket(){
    //RESETAR FILTRO
    escalationController.resetFilter();
    escalationController.update();
    Get.toNamed('/escalation/market');
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENTOS DO USUARIO COMO MAP
    List<Map<String, dynamic>> userEvents = escalationController.myEvents.map((event){
      return {'id': event.id, 'title' : event.title, 'photo': event.photo};
    }).toList();
    //DEFINIR COR A PARTIR DO TEMA
    final color = Get.isDarkMode ? AppColors.dark_300 : AppColors.white;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Escalação',
        leftAction: () => Get.back(),
        rightAction: () => goToMarket(),
        rightIcon: Icons.shopping_cart,
        extraAction: () => Get.toNamed('/escalation/historic'),
        extraIcon: Icons.history,
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
                  color: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark_500.withAlpha(30),
                      spreadRadius: 0.5,
                      blurRadius: 7,
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                child: Obx((){
                  //RESGATAR VALOR DE PATRIMONIO DO TECNICO
                  var managerPatrimony = escalationController.managerPatrimony.value;
                  //RESGATAR PREÇO DA EQUIPE DO TECNICO
                  var managerTeamPrice = escalationController.managerTeamPrice.value;
                  //RESGATAR VALORIZAÇÃO DO PATRIMONIO DO TECNICO
                  var managerValuation = escalationController.managerValuation.value;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: dimensions.width * 0.25,
                        child: ButtonDropdownIconWidget(
                          selectedItem: escalationController.selectedEvent!.id,
                          items: userEvents,
                          onChange: selectEvent,
                          iconAfter: false,
                          backgroundColor: Get.isDarkMode ? AppColors.dark_300 : AppColors.white,
                        ),
                      ),
                      SizedBox(
                        width: dimensions.width * 0.22,
                        child: PriceIndicatorWidget(
                          title: 'Preço da Equipe',
                          value: '$managerTeamPrice'
                        ),
                      ),
                      SizedBox(
                        width: dimensions.width * 0.22,
                        child: Row(
                          children: [
                            PriceIndicatorWidget(
                              value: '$managerPatrimony',
                              title: 'FutCoins',
                            ),
                            if(managerValuation != 0.0)...[
                              Icon(
                                AppHelper.setColorPontuation(managerValuation)['icon'],
                                size: 20,
                                color: AppHelper.setColorPontuation(managerValuation)['color'],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  );
                })
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: ( dimensions.width / 2 ) -10,
                      child: ButtonFormationWidget(
                        selectedFormation: escalationController.selectedFormation.value, 
                        onChange: selectFormation
                      ),
                    ),
                    SizedBox(
                      width: ( dimensions.width / 2 ) -10 ,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ButtonIconWidget(
                              padding: 20,
                              iconSize: 20,
                              icon: AppIcones.escalacao_outline, 
                              iconColor: viewType == 'escalation' ? AppColors.blue_500 : AppColors.gray_500,
                              backgroundColor: viewType == 'escalation' ? AppColors.green_300 : color,
                              action: () => selectView('escalation')
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: ButtonIconWidget(
                              padding: 20,
                              iconSize: 20,
                              icon: AppIcones.clipboard_outline, 
                              iconColor: viewType == 'list' ? AppColors.blue_500 : AppColors.gray_500,
                              backgroundColor: viewType == 'list' ? AppColors.green_300 : color,
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
              if (viewType == 'escalation') ...[
                EscalationWidget(
                  width: dimensions.width - 80,
                  height: (dimensions.height / 2) + 50,
                  category: escalationController.selectedCategory.value,
                  formation: escalationController.selectedFormation.value
                ),
                const SizedBox(height: 50),
                const Text(
                  'Reservas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ReserveBankWidget(
                  category: escalationController.selectedCategory.value,
                ),
              ] else ...[
                const EscalationListWidget(
                  title: 'Titulares',
                  occupation: 'starters',
                ),
                const SizedBox(height: 20),
                const EscalationListWidget(
                  title: 'Reservas',
                  occupation: 'reserves',
                ),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        //VERIFICAR SE EXISTEM PROXIMAS PARTIDAS
        if(!escalationController.starters.contains(null)) {
          bool hasCapitan = escalationController.selectedPlayerCapitan.value != 0;
          return FloatButtonEscalationWidget(hasCapitan: hasCapitan);
        }
        return const SizedBox.shrink();
      })
    );
  }
}