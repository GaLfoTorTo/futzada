import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/float_button_widget.dart';
import 'package:futzada/widget/indicators/indicator_loading_widget.dart';
import 'package:futzada/controllers/explorer_controller.dart';
import 'package:futzada/controllers/map_controller.dart';
import 'package:futzada/pages/explore/map/map_widget.dart';

class MapExplorePage extends StatefulWidget {
  const MapExplorePage({super.key});

  @override
  State<MapExplorePage> createState() => _MapExplorePageState();
}

class _MapExplorePageState extends State<MapExplorePage> {
  //CONTROLLER DO EXPLORE
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
  void dispose() {
    //FINALIZAR CONTROLLER DE ENDEREÇOS
    exploreController.dispose();
    //REMOVER CONTROLLER DE MAP (CUSTOM)
    mapWidgetController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            backgroundColor: AppColors.green_300,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.blue_500),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ),
      body: Obx(() {
        //EXIBIR LOADING DE CARREGAMENTO DO MAPA
        if (!mapWidgetController.isLoaded.value) {
          return const Center(child: IndicatorLoadingWidget());
        }else{
          return const MapWidget();
        }
      }),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 20,
        children: [
          if (!mapWidgetController.isMapReady.value)...[
            FloatButtonWidget(
              floatKey: "list_map",
              icon: Icons.list_rounded,
              onPressed: () => Get.offNamed('/explore/search'),
            ),
            FloatButtonWidget(
              floatKey: "filter_map",
              icon: Icons.filter_alt,
              onPressed: () => Get.toNamed('/explore/filter'),
            ),
            FloatButtonWidget(
              floatKey: "position_map",
              icon: Icons.my_location_rounded,
              onPressed: () => mapWidgetController.moveMapCurrentUser(
                LatLng(
                  mapWidgetController.currentPosition.value!.latitude, 
                  mapWidgetController.currentPosition.value!.longitude
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}