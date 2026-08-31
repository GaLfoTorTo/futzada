import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:esportly/core/providers/escalation/escalation_market_provider.dart';
import 'package:esportly/core/providers/escalation/escalation_session_provider.dart';
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

class MarketPage extends ConsumerStatefulWidget {
  const MarketPage({super.key});

  @override
  ConsumerState<MarketPage> createState() => MarketPageState();
}

class MarketPageState extends ConsumerState<MarketPage> {

  @override
  void initState() {
    super.initState();
  }

  void selectFilter(String name, dynamic newValue) {
    ref.read(escalationMarketProvider.notifier).setFilter(name, newValue);
  }

  @override
  Widget build(BuildContext context) {
    final dimensions = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.dark_500 : AppColors.white;
    final market = ref.watch(escalationMarketProvider);
    final session = ref.watch(escalationSessionProvider);
    final pesquisaController = ref.read(escalationMarketProvider.notifier).pesquisaController;

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
                      offset: const Offset(2, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InputTextWidget(
                      name: 'search',
                      hint: 'Pesquisa',
                      prefixIcon: AppIcones.search_solid,
                      textController: pesquisaController,
                      type: TextInputType.text,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ButtonDropdownWidget(
                          selectedItem: market.filtrosMarket['price'],
                          items: market.filterOptions['price'] as List<dynamic>,
                          onChange: (newValue) => selectFilter('price', newValue),
                          textSize: AppSize.fontMd,
                          width: (dimensions.width / 3) - 10,
                        ),
                        const SizedBox(
                          height: 50,
                          width: 1,
                          child: VerticalDivider(color: AppColors.grey_300, thickness: 1),
                        ),
                        ButtonDropdownMultiWidget(
                          selectedItems: market.filtrosMarket['status'] as List<dynamic>,
                          items: market.filterOptions['status'] as List<dynamic>,
                          onChanged: (newValue) => selectFilter('status', newValue),
                          textSize: AppSize.fontSm,
                          width: (dimensions.width / 3) - 10,
                        ),
                        const SizedBox(
                          height: 50,
                          width: 1,
                          child: VerticalDivider(color: AppColors.grey_300, thickness: 1),
                        ),
                        ButtonTextWidget(
                          text: "Filtros",
                          backgroundColor: isDark ? AppColors.dark_500 : AppColors.white,
                          textColor: isDark ? AppColors.white : AppColors.blue_500,
                          textSize: AppSize.fontSm,
                          icon: AppIcones.filter_solid,
                          iconAfter: true,
                          width: (dimensions.width / 3) - 50,
                          action: () => showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
                            builder: (_) => const BottomSheetMarket(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  spacing: 10,
                  children: [
                    if (market.playersFiltered.isNotEmpty) ...[
                      ...market.playersFiltered.map((item) {
                        final participant = item.participants![0];
                        return CardPlayerMarketWidget(
                          user: item,
                          participant: participant,
                          modality: session.event!.modality!.name,
                        );
                      }),
                    ] else ...[
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
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: AppColors.grey_500, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(
                              Icons.person_off,
                              color: AppColors.grey_300,
                              size: 150,
                            ),
                            Text(
                              'Verifique a aplicação de filtros ou faça uma nova pesquisa.',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: AppColors.grey_500, fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
