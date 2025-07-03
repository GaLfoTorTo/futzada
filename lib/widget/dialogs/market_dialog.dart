import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:futzada/widget/buttons/button_dropdown_multi_widget.dart';
import 'package:futzada/widget/inputs/input_checkbox_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/widget/buttons/button_dropdown_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/inputs/select_rounded_widget.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';

class MarketDialog extends StatefulWidget {

  const MarketDialog({super.key});

  @override
  State<MarketDialog> createState() => MarketDialogState();
}

class MarketDialogState extends State<MarketDialog> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instance;

  @override
  void initState() {
    super.initState();
  }

  //FUNÇÃO PARA SELECIONAR FILTRO POR STATUS
  void selectFilter(String name, dynamic newValue){
    setState(() {
      controller.setFilter(name, newValue);
      controller.update();
    });
  }

  //FUNÇÃO PARA APLICAR CONFIGURAÇÕES DE FILTRO
  void applyFilter(){
    //FECHAR BOTTOM SHEET
    Get.back();
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    //LISTA DE METRICAS DO CARD
    List<Map<String, dynamic>> metricOptions = [
      {
        'name':'price',
        'label':'Preço',
        'icon': AppIcones.money_check_solid,
        'selectedItem' : controller.filtrosMarket['price'],
        'itens': controller.filterOptions['price'],
        'width' : 3
      },
      {
        'name':'media',
        'label':'Média',
        'icon': AppIcones.chart_line_solid,
        'selectedItem' : controller.filtrosMarket['media'],
        'itens': controller.filterOptions['media'],
        'width' : 3
      },
      {
        'name':'games',
        'label':'Jogos',
        'icon': AppIcones.clipboard_solid,
        'selectedItem' : controller.filtrosMarket['game'],
        'itens': controller.filterOptions['games'],
        'width' : 3
      },
      {
        'name':'lastPontuation',
        'label':'Última Pontuação',
        'icon': AppIcones.calculator_solid,
        'selectedItem' : controller.filtrosMarket['lastPontuation'],
        'itens': controller.filterOptions['lastPontuation'],
        'width' : 2
      },
      {
        'name':'valorization',
        'label':'Valorização',
        'icon': AppIcones.sort_amount_up_solid,
        'selectedItem' : controller.filtrosMarket['valorization'],
        'itens': controller.filterOptions['valorization'],
        'width' : 2
      },
      {
        'name':'nome',
        'label':'Ordenar',
        'icon': AppIcones.money_check_solid,
        'selectedItem' : controller.filtrosMarket['nome'],
        'itens': controller.filterPlayerOptions['nome'],
        'width' : 2
      },
      {
        'name':'status',
        'label':'Status',
        'icon': AppIcones.check_circle_solid,
        'selectedItem' : controller.filtrosMarket['status'],
        'itens': controller.filterOptions['status'],
        'width' : 2
      },
    ];
    
    //LISTA DE MELHOR PÉ
    List<Map<String, dynamic>> bestSideOptions = [
      {'value': 'Esquerda', 'icon': AppIcones.foot_left_solid, 'checked': controller.filtrosMarket['bestSide'] == 'Esquerda' ? true : false},
      {'value': 'Direita', 'icon': AppIcones.foot_right_solid, 'checked': controller.filtrosMarket['bestSide'] == 'Direita' ? true : false},
    ];
    
    //LISTA DE STATUS DISPONIVEIS
    List<Map<String, dynamic>> positionsOptions = [
      {'label': 'ATA','value': 'ata', 'icon': AppIcones.posicao['ata'], 'checked': controller.filtrosMarket['positions'].contains('ATA') ? true : false},
      {'label': 'MEI','value': 'mei', 'icon': AppIcones.posicao['mei'], 'checked': controller.filtrosMarket['positions'].contains('MEI') ? true : false},
      {'label': 'ZAG','value': 'zag', 'icon': AppIcones.posicao['zag'], 'checked': controller.filtrosMarket['positions'].contains('ZAG') ? true : false},
      {'label': 'GOL','value': 'gol', 'icon': AppIcones.posicao['gol'], 'checked': controller.filtrosMarket['positions'].contains('GOL') ? true : false},
    ];

    return  SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: Column(
                children: [
                  Text(
                    'Filtros',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(
                    width: dimensions.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Metricas',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Wrap(
                          spacing: 10,
                          children: [
                            ...metricOptions.asMap().entries.map((entry){
                              final item = entry.value;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      item['label'],
                                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if(item['label'] == 'Status')...[
                                    ButtonDropdownMultiWidget(
                                      selectedItems: controller.filtrosMarket['status'] as List<dynamic>,
                                      items: controller.filterOptions['status'] as List<dynamic>, 
                                      onChanged: (newValue) => selectFilter('status', newValue),
                                      textSize: AppSize.fontSm,
                                      borderColor: AppColors.gray_300,
                                      width: ( dimensions.width / 2 ) - 20,
                                    ),
                                  ]else...[
                                    ButtonDropdownWidget(
                                      width: ( dimensions.width / 2 ) - 20,
                                      menuWidth: ( dimensions.width / 2 ),
                                      selectedItem: item['selectedItem'], 
                                      items: item['itens'], 
                                      textSize: AppSize.fontSm,
                                      borderColor: AppColors.gray_300,
                                      aligment: item['name'] == 'status' ? 'center' : 'centerLeft',
                                      onChange: (newValue) => selectFilter(item['name'], newValue),
                                    ),
                                  ]
                                ],
                              );
                            }),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Jogador',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Posições',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...positionsOptions.asMap().entries.map((entry){
                              final item = entry.value;
                              return Column(
                                children: [
                                  SvgPicture.asset(
                                    item['icon'],
                                    width: 25,
                                    height: 25,
                                  ),
                                  InputCheckBoxWidget(
                                    name: item['label'],
                                    value: item['checked'],
                                    onChanged: (newValue) => selectFilter('positions', newValue as String),
                                  ),
                                ],
                              );
                            }),
                          ]
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'Melhor Pé',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ...bestSideOptions.asMap().entries.map((entry){
                              final item = entry.value;
                              return SelectRoundedWidget(
                                size: 100,
                                iconSize: 70,
                                value: item['value'],
                                icon: item['icon'],
                                checked: item['checked'],
                                onChanged: (newValue) => selectFilter('bestSide', newValue),
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonTextWidget(
                  text: "Cancelar",
                  width: dimensions.width / 3,
                  height: 30,
                  backgroundColor: AppColors.red_300,
                  textColor: AppColors.white,
                  action: () => Get.back(),
                ),
                ButtonTextWidget(
                  text: "Aplicar",
                  width: dimensions.width / 3,
                  height: 30,
                  backgroundColor: AppColors.green_300,
                  textColor: AppColors.white,
                  action: () => Get.back(),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}