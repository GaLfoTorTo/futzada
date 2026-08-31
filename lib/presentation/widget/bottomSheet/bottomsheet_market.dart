import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/theme/app_size.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/theme/app_icones.dart';
import 'package:esportly/core/providers/escalation/escalation_market_provider.dart';
import 'package:esportly/presentation/widget/badges/position_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_dropdown_multi_widget.dart';
import 'package:esportly/presentation/widget/inputs/input_checkbox_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_dropdown_widget.dart';
import 'package:esportly/presentation/widget/buttons/button_text_widget.dart';
import 'package:esportly/presentation/widget/inputs/select_rounded_widget.dart';

class BottomSheetMarket extends ConsumerWidget {
  const BottomSheetMarket({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dimensions = MediaQuery.of(context).size;
    final market = ref.watch(escalationMarketProvider);

    void selectFilter(String name, dynamic newValue) {
      ref.read(escalationMarketProvider.notifier).setFilter(name, newValue);
    }

    final List<Map<String, dynamic>> metricOptions = [
      {
        'name': 'price',
        'label': 'Preço',
        'icon': AppIcones.money_check_solid,
        'selectedItem': market.filtrosMarket['price'],
        'itens': market.filterOptions['price'],
        'width': 3,
      },
      {
        'name': 'media',
        'label': 'Média',
        'icon': AppIcones.chart_line_solid,
        'selectedItem': market.filtrosMarket['media'],
        'itens': market.filterOptions['media'],
        'width': 3,
      },
      {
        'name': 'games',
        'label': 'Jogos',
        'icon': AppIcones.clipboard_solid,
        'selectedItem': market.filtrosMarket['game'],
        'itens': market.filterOptions['games'],
        'width': 3,
      },
      {
        'name': 'lastPontuation',
        'label': 'Última Pontuação',
        'icon': AppIcones.calculator_solid,
        'selectedItem': market.filtrosMarket['lastPontuation'],
        'itens': market.filterOptions['lastPontuation'],
        'width': 2,
      },
      {
        'name': 'valorization',
        'label': 'Valorização',
        'icon': AppIcones.sort_amount_up_solid,
        'selectedItem': market.filtrosMarket['valorization'],
        'itens': market.filterOptions['valorization'],
        'width': 2,
      },
      {
        'name': 'nome',
        'label': 'Ordenar',
        'icon': AppIcones.money_check_solid,
        'selectedItem': market.filtrosMarket['nome'],
        'itens': market.filterPlayerOptions['nome'],
        'width': 2,
      },
      {
        'name': 'status',
        'label': 'Status',
        'icon': AppIcones.check_circle_solid,
        'selectedItem': market.filtrosMarket['status'],
        'itens': market.filterOptions['status'],
        'width': 2,
      },
    ];

    final List<Map<String, dynamic>> bestSideOptions = [
      {
        'value': 'Esquerda',
        'icon': AppIcones.foot_left_solid,
        'checked': market.filtrosMarket['bestSide'] == 'Esquerda',
      },
      {
        'value': 'Direita',
        'icon': AppIcones.foot_right_solid,
        'checked': market.filtrosMarket['bestSide'] == 'Direita',
      },
    ];

    final List<Map<String, dynamic>> positionsOptions = [
      {'label': 'ATA', 'value': 'ata', 'checked': market.filtrosMarket['positions'].contains('ATA')},
      {'label': 'MEI', 'value': 'mei', 'checked': market.filtrosMarket['positions'].contains('MEI')},
      {'label': 'ZAG', 'value': 'zag', 'checked': market.filtrosMarket['positions'].contains('ZAG')},
      {'label': 'GOL', 'value': 'gol', 'checked': market.filtrosMarket['positions'].contains('GOL')},
    ];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('Filtros', style: Theme.of(context).textTheme.headlineLarge),
                SizedBox(
                  width: dimensions.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('Metricas', style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Wrap(
                        spacing: 10,
                        children: metricOptions.map((item) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  item['label'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (item['label'] == 'Status') ...[
                                ButtonDropdownMultiWidget(
                                  selectedItems: market.filtrosMarket['status'] as List<dynamic>,
                                  items: market.filterOptions['status'] as List<dynamic>,
                                  onChanged: (newValue) => selectFilter('status', newValue),
                                  textSize: AppSize.fontSm,
                                  borderColor: AppColors.grey_300,
                                  width: (dimensions.width / 2) - 20,
                                ),
                              ] else ...[
                                ButtonDropdownWidget(
                                  width: (dimensions.width / 2) - 20,
                                  menuWidth: (dimensions.width / 2),
                                  selectedItem: item['selectedItem'],
                                  items: item['itens'],
                                  textSize: AppSize.fontSm,
                                  borderColor: AppColors.grey_300,
                                  aligment: item['name'] == 'status' ? 'center' : 'centerLeft',
                                  onChange: (newValue) => selectFilter(item['name'], newValue),
                                ),
                              ],
                            ],
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text('Jogador', style: Theme.of(context).textTheme.titleMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Posições',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: positionsOptions.map((item) {
                          return Column(
                            children: [
                              PositionWidget(
                                position: item["label"],
                                mainPosition: true,
                                width: 35,
                                height: 25,
                                textSide: 10,
                              ),
                              InputCheckBoxWidget(
                                name: item['label'],
                                value: item['checked'],
                                onChanged: (newValue) =>
                                    selectFilter('positions', newValue as String),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'Melhor Pé',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: bestSideOptions.map((item) {
                          return SelectRoundedWidget(
                            size: 100,
                            iconSize: 70,
                            value: item['value'],
                            icon: item['icon'],
                            checked: item['checked'],
                            onChanged: (newValue) => selectFilter('bestSide', newValue),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
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
                  action: () => Navigator.of(context).pop(),
                ),
                ButtonTextWidget(
                  text: "Aplicar",
                  width: dimensions.width / 3,
                  height: 30,
                  backgroundColor: AppColors.green_300,
                  textColor: AppColors.white,
                  action: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
