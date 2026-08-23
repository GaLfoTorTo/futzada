import 'package:flutter/material.dart';
import 'package:esportly/presentation/controllers/escalation_controller.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/theme/app_size.dart';
import 'package:esportly/presentation/widget/buttons/button_dropdown_multi_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_dropdown_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/cards/card_player_market_widget.dart';
import 'package:esportly/presentation/widget/bottomSheet/bottomsheet_market.dart';
import 'package:esportly/presentation/widget/inputs/input_text_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:esportly/presentation/widget/bars/header_widget.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  //RESGATAR CONTROLLER DE ESCALAÇÃO
  EscalationController escalationController = EscalationController.instance;
  //DEFINIR COR A PARTIR DO TEMA (calculado no build via context)
  Color get _color => AppColors.white; // sobrescrito no build

  //FUNÇÃO PARA SELECIONAR FILTRO POR STATUS
  void selectFilter(String name, dynamic newValue){
    setState(() {
      escalationController.setFilter(name, newValue);
          });
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.dark_500 : AppColors.white;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Mercado',
        leftAction: () => context.pop(),
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
                  color: color,
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
                      prefixIcon: AppIcones.search_solid,
                      textController: escalationController.pesquisaController,
                      type: TextInputType.text,
                    ),
                    ListenableBuilder(listenable: escalationController, builder: (_, __){
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ButtonDropdownWidget(
                            selectedItem: escalationController.filtrosMarket['price'],
                            items: escalationController.filterOptions['price'] as List<dynamic>, 
                            onChange: (newValue) => selectFilter('price', newValue),
                            textSize: AppSize.fontMd,
                            width: ( dimensions.width / 3 ) - 10,
                          ),
                          const SizedBox(
                            height: 50,
                            width: 1,
                            child: VerticalDivider(
                              color: AppColors.grey_300,
                              thickness: 1,
                            ),
                          ),
                          ButtonDropdownMultiWidget(
                            selectedItems: escalationController.filtrosMarket['status'] as List<dynamic>,
                            items: escalationController.filterOptions['status'] as List<dynamic>, 
                            onChanged: (newValue) => selectFilter('status', newValue),
                            textSize: AppSize.fontSm,
                            width: ( dimensions.width / 3 ) - 10,
                          ),
                          const SizedBox(
                            height: 50,
                            width: 1,
                            child: VerticalDivider(
                              color: AppColors.grey_300,
                              thickness: 1,
                            ),
                          ),
                          ButtonTextWidget(
                            text: "Filtros",
                            backgroundColor: isDark ? AppColors.dark_500 : AppColors.white,
                            textColor: isDark ? AppColors.white : AppColors.blue_500,
                            textSize: AppSize.fontSm,
                            icon: AppIcones.filter_solid,
                            iconAfter: true,
                            width: ( dimensions.width / 3 ) - 50,
                            action: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => const BottomSheetMarket(),
                            )
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
                  spacing: 10,
                  children: [
                    if(escalationController.filteredPlayersMarket.isNotEmpty)...[
                      ...escalationController.filteredPlayersMarket.map((entry) {
                        //RESGATAR ITENS 
                        final item = entry;
                        return  CardPlayerMarketWidget(
                          user: item,
                          modality: escalationController.event!.modality!.name,
                        );
                      }),
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
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.grey_500, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(
                              Icons.person_off,
                              color: AppColors.grey_300,
                              size: 150,
                            ),
                            Text(
                              'Verifique a aplicação de filtros ou faça uma nova pesquisa.', 
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.grey_500, fontWeight: FontWeight.normal),
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