import 'package:flutter/material.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/widget/buttons/button_dropdown_icon_widget.dart';
import 'package:futzada/widget/indicators/indicator_valuation_widget.dart';
import 'package:futzada/widget/lists/escalation_list_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_widget.dart';
import 'package:futzada/widget/buttons/button_formation_widget.dart';
import 'package:futzada/widget/buttons/button_icon_widget.dart';
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
  var controller = EscalationController.instance;

  //FUNÇÃO PARA SELECIONAR EVENTO
  void selectEvent(newValue){
    setState(() {
      //SELECIONAR EVENTO
      controller.setEvent(newValue);
      //ATUALIZAR CONTROLLER
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
  
  //FUNÇÃO PARA DEFINIR FILTROS QUANDO NEVEGAÇÃO FOR DIRETO PARA MERCADO
  void goToMarket(){
    //RESETAR FILTRO
    controller.resetFilter();
    controller.update();
    Get.toNamed('/escalation/market');
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENTOS DO USUARIO COMO MAP
    List<Map<String, dynamic>> userEvents = controller.myEvents.map((event){
      return {'id': event.id, 'title' : event.title, 'photo': event.photo};
    }).toList();

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
                  color: AppColors.white,
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
                  var managerPatrimony = controller.managerPatrimony.value;
                  //RESGATAR PREÇO DA EQUIPE DO TECNICO
                  var managerTeamPrice = controller.managerTeamPrice.value;
                  //RESGATAR VALORIZAÇÃO DO PATRIMONIO DO TECNICO
                  var managerValuation = controller.managerValuation;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: dimensions.width * 0.25,
                        child: ButtonDropdownIconWidget(
                          selectedItem: controller.selectedEvent!.id,
                          items: userEvents,
                          onChange: selectEvent,
                          iconAfter: false,
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
                        selectedFormation: controller.selectedFormation, 
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
                              icon: AppIcones.escalacao_outline, 
                              iconColor: viewType == 'escalation' ? AppColors.blue_500 : AppColors.gray_500,
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
                              iconColor: viewType == 'list' ? AppColors.blue_500 : AppColors.gray_500,
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
              if (viewType == 'escalation') ...[
                CampoWidget(
                  width: dimensions.width - 80,
                  height: (dimensions.height / 2) + 50,
                ),
                const SizedBox(height: 50),
                const Text(
                  'Reservas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ReserveBankWidget(
                  category: controller.selectedCategory,
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
    );
  }
}