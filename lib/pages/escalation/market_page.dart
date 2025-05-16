import 'package:flutter/material.dart';
import 'package:futzada/controllers/escalation_controller.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/theme/app_size.dart';
import 'package:futzada/widget/buttons/button_dropdown_multi_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/cards/card_player_market_widget.dart';
import 'package:futzada/widget/dialogs/market_dialog_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:get/get.dart';
import 'package:futzada/widget/bars/header_widget.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  var controller = EscalationController.instace;

  //FUNÇÃO PARA SELECIONAR FILTRO POR STATUS
  void selectFilter(String name, dynamic newValue){
    setState(() {
      controller.setFilter(name, newValue);
      controller.update();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: HeaderWidget(
        title: 'Mercado',
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: dimensions.width,
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
                child: Column(
                  children: [
                    InputTextWidget(
                      name: 'search',
                      hint: 'Pesquisa',
                      bgColor: AppColors.gray_300.withAlpha(50),
                      prefixIcon: AppIcones.search_solid,
                      textController: controller.pesquisaController,
                      controller: controller,
                      type: TextInputType.text,
                    ),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ButtonDropdownWidget(
                            selectedItem: controller.filtrosMarket['price'],
                            items: controller.filterOptions['price'] as List<dynamic>, 
                            onChange: (newValue) => selectFilter('price', newValue),
                            textSize: AppSize.fontSm,
                            width: ( dimensions.width / 3 ) - 10,
                          ),
                          const SizedBox(
                            height: 50,
                            width: 1,
                            child: VerticalDivider(
                              color: AppColors.gray_300,
                              thickness: 1,
                            ),
                          ),
                          ButtonDropdownMultiWidget(
                            selectedItems: controller.filtrosMarket['status'] as List<dynamic>,
                            items: controller.filterOptions['status'] as List<dynamic>, 
                            onChanged: (newValue) => selectFilter('status', newValue),
                            textSize: AppSize.fontSm,
                            width: ( dimensions.width / 3 ) - 10,
                          ),
                          const SizedBox(
                            height: 50,
                            width: 1,
                            child: VerticalDivider(
                              color: AppColors.gray_300,
                              thickness: 1,
                            ),
                          ),
                          ButtonTextWidget(
                            backgroundColor: AppColors.white,
                            text: "Filtros",
                            textSize: AppSize.fontSm,
                            textColor: AppColors.blue_500,
                            icon: AppIcones.filter_solid,
                            iconAfter: true,
                            width: ( dimensions.width / 3 ) - 50,
                            action: () => Get.bottomSheet(MarketDialogWidget(), isScrollControlled: true)
                          ),
                        ],
                      );
                    })
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    if(controller.playersMarket.isNotEmpty)...[
                      ...controller.playersMarket.map((entry) {
                        //RESGATAR ITENS 
                        final item = entry;
                        return  CardPlayerMarketWidget(
                          player: item,
                          escalation: controller.escalation['starters']!
                        );
                      }).toList(),
                    ]else...[
                      Container(
                        alignment: Alignment.center,
                        width: dimensions.width,
                        height: dimensions.height / 2,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Nenhum jogador encontrado', 
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.gray_500, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(
                              Icons.person_off,
                              color: AppColors.gray_300,
                              size: 150,
                            ),
                            Text(
                              'Verifique a aplicação de filtros ou faça uma nova pesquisa.', 
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.gray_500, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ]
                        )
                      )
                    ]
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}