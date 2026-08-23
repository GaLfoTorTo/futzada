import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:esportly/core/theme/app_colors.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/presentation/widget/buttons/float_button_widget.dart';
import 'package:esportly/presentation/widget/indicators/indicator_loading_widget.dart';
import 'package:esportly/presentation/widget/bottomSheet/bottomsheet_addres.dart';
import 'package:esportly/presentation/controllers/address_controller.dart';
import 'package:esportly/presentation/controllers/map_controller.dart';
import 'package:esportly/presentation/pages/explore/map/map_widget.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  //RESGATAR CONTROLLER DE ENDEREÇOS
  late AddressController addressController;
  //RESGATAR CONTROLLER DE MAPA (CUSTOM)
  late MapWidgetController mapWidgetController;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE EXPLORER
    addressController = AddressController()..init();
    //INICIALIZAR CONTROLLER DE MAP (CUSTOM) e registrar no GetIt
    mapWidgetController = MapWidgetController(model: 'Address')..init();
    sl.registerSingleton<MapWidgetController>(mapWidgetController);
  }

  @override
  void dispose() {
    //FINALIZAR CONTROLLER DE ENDEREÇOS
    addressController.dispose();
    //REMOVER CONTROLLER DE MAP (CUSTOM) do GetIt e dispor
    if (sl.isRegistered<MapWidgetController>()) sl.unregister<MapWidgetController>();
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
      body: ListenableBuilder(listenable: Listenable.merge([mapWidgetController, addressController]), builder: (_, __){
        //EXIBIR LOADING DE CARREGAMENTO DO MAPA
        if (!mapWidgetController.isLoaded) {
          return const Center(child: IndicatorLoadingWidget());
        }else{
          return MapWidget(mapWidgetController: mapWidgetController);
        }
      }),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 20,
        children: [
          if (!mapWidgetController.isMapReady)...[
            FloatButtonWidget(
              floatKey: "search_map",
              icon: Icons.search_rounded,
              onPressed: () => showModalBottomSheet(context: context, isScrollControlled: true, builder: (_) => BottomSheetAddress()),
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