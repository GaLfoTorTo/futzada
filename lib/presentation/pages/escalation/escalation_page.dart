import 'package:futzada/presentation/controllers/showcase_controller.dart';
import 'package:futzada/presentation/widget/showcase/wizard_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/core/theme/app_icones.dart';
import 'package:futzada/presentation/controllers/escalation_controller.dart';
import 'package:futzada/presentation/pages/erros/erro_escalation_page.dart';
import 'package:futzada/presentation/widget/buttons/float_button_escalation_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_loading_widget.dart';
import 'package:futzada/presentation/widget/bars/header_widget.dart';
import 'package:futzada/presentation/widget/text/price_indicator_widget.dart';
import 'package:futzada/presentation/widget/lists/escalation_list_widget.dart';
import 'package:futzada/presentation/widget/others/escalation_widget.dart';
import 'package:futzada/presentation/widget/others/reserve_bank_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_icon_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_dropdown_icon_widget.dart';
import 'package:futzada/presentation/widget/buttons/button_formation_widget.dart';

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
  ShowcaseController showcaseController = ShowcaseController.instance;

  //FUNÇÃO PARA SELECIONAR EVENTO
  void selectEvent(id){
    setState(() {
      //SELECIONAR EVENTO
      escalationController.setEvent(id);
      //ATUALIZAR CONTROLLER
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
      escalationController.formation = newValue;
          });
  }
  
  //FUNÇÃO PARA DEFINIR FILTROS QUANDO NEVEGAÇÃO FOR DIRETO PARA MERCADO
  void goToMarket(BuildContext context){
    //RESETAR FILTRO
    escalationController.resetFilter();
        context.push('/escalation/market');
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    //RESGATAR EVENTOS DO USUARIO COMO MAP
    List<Map<String, dynamic>> userEvents = escalationController.events.map((event){
      return {'id': event.id, 'title' : event.title, 'photo': event.photo};
    }).toList();
    //DEFINIR COR A PARTIR DO TEMA
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.dark_300 : AppColors.white;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Escalação',
        leftAction: () => context.pop(),
        rightAction: () => goToMarket(context),
        rightIcon: Icons.shopping_cart,
        extraAction: () => context.push('/escalation/historic'),
        extraIcon: Icons.history,
        shadow: false,
      ),
      body: SafeArea(
        child: ListenableBuilder(listenable: Listenable.merge([escalationController, showcaseController]), builder: (_, __){
          if(escalationController.isLoading){
            return const Center(child: IndicatorLoadingWidget());
          }
          if(escalationController.hasError){
            //EXIBIR DIALOG DE ERRO
            return const ErroEscalationPage();
          }
          return SingleChildScrollView(
            child: Column(
              spacing: 10,
              children: [
                Container(
                  width: dimensions.width,
                  height: 70,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.dark_500 : AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.dark_500.withAlpha(30),
                        spreadRadius: 0.5,
                        blurRadius: 7,
                        offset: const Offset(2, 5),
                      ),
                    ],
                  ),
                  child: ListenableBuilder(listenable: Listenable.merge([escalationController, showcaseController]), builder: (_, __){
                    //RESGATAR VALOR DE PATRIMONIO DO TECNICO
                    var managerPatrimony = escalationController.managerPatrimony;
                    //RESGATAR PREÇO DA EQUIPE DO TECNICO
                    var managerTeamPrice = escalationController.managerTeamPrice;
                    //RESGATAR VALORIZAÇÃO DO PATRIMONIO DO TECNICO
                    var managerValuation = escalationController.managerValuation;
                    if(!escalationController.isReady){
                      return SizedBox.shrink();
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: dimensions.width * 0.25,
                          child: ButtonDropdownIconWidget(
                            selectedItem: escalationController.event!.id,
                            items: userEvents,
                            onChange: selectEvent,
                            iconAfter: false,
                            backgroundColor: isDark ? AppColors.dark_300 : AppColors.white,
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
                Container(
                  width: dimensions.width,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: ( dimensions.width / 2 ) -10,
                        child: ButtonFormationWidget(
                          selectedFormation: escalationController.formation, 
                          onChange: selectFormation
                        ),
                      ),
                      SizedBox(
                        width: ( dimensions.width / 2 ) -10 ,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          spacing: 10,
                          children: [
                            WizardWidget(
                              elementKey: 'escalation',
                              child: ButtonIconWidget(
                                padding: 20,
                                iconSize: 20,
                                icon: AppIcones.escalacao_outline, 
                                iconColor: viewType == 'escalation' ? AppColors.blue_500 : AppColors.grey_500,
                                backgroundColor: viewType == 'escalation' ? AppColors.green_300 : color,
                                action: () => selectView('escalation')
                              ),
                            ),
                            ButtonIconWidget(
                              padding: 20,
                              iconSize: 20,
                              icon: AppIcones.clipboard_outline, 
                              iconColor: viewType == 'list' ? AppColors.blue_500 : AppColors.grey_500,
                              backgroundColor: viewType == 'list' ? AppColors.green_300 : color,
                              action: () => selectView('list')
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //VERIFICAR TIPO DE VISUALIZAÇÃO (ESCALAÇÃO OU LISTA)
                if (viewType == 'escalation') ...[
                  EscalationWidget(
                    width: dimensions.width - 80,
                    height: (dimensions.height / 2) + 50,
                    category: escalationController.category,
                    formation: escalationController.formation
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Reservas',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ReserveBankWidget(
                    category: escalationController.category,
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
            )
          );
        })
      ),
      floatingActionButton: ListenableBuilder(listenable: Listenable.merge([escalationController, showcaseController]), builder: (_, __){
        //VERIFICAR SE EXISTEM PROXIMAS PARTIDAS
        if(escalationController.isReady && !escalationController.starters.contains(null)) {
          bool hasCapitan = escalationController.selectedPlayerCapitan != 0;
          return FloatButtonEscalationWidget(hasCapitan: hasCapitan);
        }
        return const SizedBox.shrink();
      })
    );
  }
}