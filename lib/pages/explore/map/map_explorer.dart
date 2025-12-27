import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/pages/explore/map/map_widget.dart';
import 'package:futzada/widget/buttons/float_button_map_widget.dart';
import 'package:futzada/controllers/explorer_controller.dart';
import 'package:futzada/controllers/map_controller.dart';

class MapExplorer extends StatefulWidget {
  const MapExplorer({super.key});

  @override
  State<MapExplorer> createState() => _MapExplorerState();
}

class _MapExplorerState extends State<MapExplorer> {
  //CONTROLLER DO MAPA (CUSTOM)
  late ExplorerController explorerController;
  //RESGATAR CONTROLLER DE MAPA (CUSTOM)
  late MapWidgetController mapWidgetController;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE EXPLORER
    explorerController = Get.put(ExplorerController());
    //INICIALIZAR CONTROLLER DE MAP (CUSTOM)
    mapWidgetController = Get.put(MapWidgetController());
  }

  @override
  void dispose() {
    //FINALIZAR CONTROLLER DE ENDEREÇOS
    explorerController.dispose();
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
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.green_300,
            )
          );
        }else{
          return const MapWidget();
        }
      }),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 20,
        children: [
          FloatButtonMapWidget(
            floatKey: "filter_map",
            icon: Icons.filter_alt,
            onPressed: () => {},
          ),
          FloatButtonMapWidget(
            floatKey: "position_map",
            icon: Icons.my_location_rounded,
            onPressed: () => mapWidgetController.moveMapCurrentUser(LatLng(
              mapWidgetController.currentPosition.value!.latitude, 
              mapWidgetController.currentPosition.value!.longitude),
            ),
          ),
        ],
      ),
    );
  }
}