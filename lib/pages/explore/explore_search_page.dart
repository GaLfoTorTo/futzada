import 'package:futzada/widget/indicators/indicator_loading_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/theme/app_icones.dart';
import 'package:futzada/controllers/explorer_controller.dart';
import 'package:futzada/controllers/map_controller.dart';
import 'package:futzada/widget/cards/card_event_search_widget.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:futzada/widget/inputs/input_text_widget.dart';
import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:futzada/widget/buttons/button_dropdown_widget.dart';

class ExploreSearchPage extends StatefulWidget {
  const ExploreSearchPage({super.key});

  @override
  State<ExploreSearchPage> createState() => _ExploreSearchPageState();
}

class _ExploreSearchPageState extends State<ExploreSearchPage> {
  //RESGATAR CONTROLLER DE EXPLORE
  late ExplorerController exploreController;
  //RESGATAR CONTROLLER DE MAPA (CUSTOM)
  late MapWidgetController mapWidgetController;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE EXPLORER
    exploreController = Get.put(ExplorerController());
    //INICIALIZAR CONTROLLER DE MAP (CUSTOM)
    mapWidgetController = Get.put(MapWidgetController());
  }

  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

    return Scaffold(
      appBar: HeaderWidget(
        title: 'Pesquisar',
        leftAction: () => Get.back(),
        shadow: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(() {
              return Container(
                padding: const EdgeInsets.all(10),
                color: Get.isDarkMode ? AppColors.dark_700 : AppColors.white,
                child: Column(
                  spacing: 5,
                  children: [
                    InputTextWidget(
                      name: 'search',
                      hint: 'Pesquisa',
                      prefixIcon: AppIcones.search_solid,
                      backgroundColor: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
                      textController: exploreController.pesquisaController,
                      type: TextInputType.text,
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonDropdownWidget(
                          selectedItem: exploreController.order.value,
                          items: ['A - Z', 'Z - A'],
                          onChange: (v) => exploreController.order.value = v,
                          width: dimensions.width * 0.25,
                          hint: "Ordenação",
                        ),
                        ButtonTextWidget(
                          text: "Filtros",
                          icon: Icons.filter_alt,
                          width: dimensions.width * 0.25,
                          textColor: Get.isDarkMode ? AppColors.white : AppColors.blue_500,
                          backgroundColor: Get.isDarkMode ? AppColors.dark_500 : AppColors.white,
                          action: () => Get.toNamed("explore/filter"),
                        ),
                        ButtonTextWidget(
                          text: "Mapa",
                          icon: Icons.map_rounded,
                          width: dimensions.width * 0.25,
                          backgroundColor: AppColors.green_300,
                          action: () => Get.offNamed("explore/map"),
                        ),
                      ],
                    ),
                    Text(
                      "${mapWidgetController.events.length} Peladas Encontradas",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.gray_300
                      ),
                    )
                  ],
                ),
              );
            }),
            Obx((){
              if(!mapWidgetController.isLoaded.value){
                return const IndicatorLoadingWidget();
              }
              if(mapWidgetController.events.isEmpty){
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text(
                        "Não foi possível buscar os eventos!",
                      ),
                      const Icon(
                        Icons.content_paste_off_rounded,
                        size: 120,
                      ),
                      ButtonTextWidget(
                        text: "Tentar Novamente!",
                        icon: Icons.refresh_rounded,
                        width: dimensions.width - 50,
                        action: () => {},
                      ),
                    ],
                  ),
                );
              }
              return Expanded(
                child: ListView(
                  children: mapWidgetController.events.map((event){
                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: CardEventSearchWidget(event: event),
                    );
                  }).toList(),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
