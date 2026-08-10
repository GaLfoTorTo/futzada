import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/theme/app_colors.dart';
import 'package:futzada/presentation/widget/buttons/float_button_widget.dart';
import 'package:futzada/presentation/widget/indicators/indicator_loading_widget.dart';
import 'package:futzada/presentation/controllers/explorer_controller.dart';
import 'package:futzada/presentation/controllers/map_controller.dart';
import 'package:futzada/presentation/pages/explore/map/map_widget.dart';

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
    //INICIALIZAR CONTROLLER DE EXPLORER (singleton compartilhado via GetIt)
    exploreController = sl<ExplorerController>();
    //INICIALIZAR CONTROLLER DE MAP (CUSTOM)
    mapWidgetController = MapWidgetController()..init();
  }

  @override
  void dispose() {
    //NÃO dispõe exploreController — é singleton gerenciado pelo GetIt
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
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: ListenableBuilder(listenable: mapWidgetController, builder: (_, __){
        //EXIBIR LOADING DE CARREGAMENTO DO MAPA
        if (!mapWidgetController.isLoaded) {
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
          if (!mapWidgetController.isMapReady)...[
            FloatButtonWidget(
              floatKey: "list_map",
              icon: Icons.list_rounded,
              onPressed: () => context.go('/explore/search'),
            ),
            FloatButtonWidget(
              floatKey: "filter_map",
              icon: Icons.filter_alt,
              onPressed: () => context.push('/explore/filter'),
            ),
            FloatButtonWidget(
              floatKey: "position_map",
              icon: Icons.my_location_rounded,
              onPressed: () => mapWidgetController.moveMapCurrentUser(
                LatLng(
                  mapWidgetController.currentPosition!.latitude, 
                  mapWidgetController.currentPosition!.longitude
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}