import 'package:futzada/widget/buttons/button_text_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futzada/api/api.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/buttons/float_button_map_widget.dart';
import 'package:futzada/widget/dialogs/address_dialog.dart';
import 'package:futzada/controllers/address_controller.dart';
import 'package:futzada/controllers/event_controller.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //RESGATAR CONTROLLER DE ENDEREÇOS
  late AddressController addressController;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE ENDEREÇOS
    addressController = Get.put(AddressController());
    //LISTENER DE EVENTOS DO MAPA 
    addressController.mapController.mapEventStream.listen((event) {
      if (event is MapEventMove) {
        addressController.currentZoom.value = event.camera.zoom;
        addressController.showClusters.value = event.camera.zoom < 14;
      }
    });
  }

  @override
  void dispose() {
    //FINALIZAR CONTROLLER DE ENDEREÇOS
    addressController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    //RESGATAR DIMENSÕES DO DISPOSITIVO
    var dimensions = MediaQuery.of(context).size;

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
        if (!addressController.isLoaded.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.green_300,
            )
          );
        }else{
          return FlutterMap(
            mapController: addressController.mapController,
            options: MapOptions(
              initialCenter: addressController.currentLatLog.value!,
              initialZoom: addressController.currentZoom.value,
              maxZoom: 18.0,
              minZoom: 10.0,
              onMapReady: () async{
                //ABRIR DIALOG
                Get.bottomSheet(AddressDialog(), isScrollControlled: true);
                //ESPERAR 2 SEGUNDOS
                await Future.delayed(const Duration(seconds: 2));
                setState(() {
                  //ATUALIZAR ESTADO DE MAPA PRONTO
                  addressController.isMapReady.value = true;
                  //MOVER MAPA PARA POSIÇÃO ATUAL DO USUÁRIO
                  addressController.moveMapCurrentUser(LatLng(addressController.currentPosition.value!.latitude, addressController.currentPosition.value!.longitude),);
                });
              }
            ),
            children: [
              //EXIBIR MENSAGEM E BOTÃO DE SOLICITAÇÃO DE PERMISSÃO PARA GEOLOCALIZAÇÃO
              if(!addressController.hasPermission.value)...[
                Container(
                  height: dimensions.height,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Conceda permissão para o aplicativo acessar sua localização',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ButtonTextWidget(
                        width: dimensions.width * 0.50,
                        text: "Permissão",
                        textColor: AppColors.blue_500,
                        action: () async => await addressController.getCurrentLocation()
                      )
                    ],
                  )
                )
              ]else...[
                TileLayer(
                  urlTemplate: AppApi.map,
                  subdomains: ['a', 'b', 'c', 'd'],
                ),
                MarkerLayer(
                  markers: [
                    //POSIÇÃO ATUAL DO USUARIO
                    Marker(
                      point: LatLng(addressController.currentPosition.value!.latitude, addressController.currentPosition.value!.longitude),
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.green_300.withAlpha(50),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: AppColors.green_300,
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: AppColors.white, width: 2),
                            ),
                          ),
                        ),
                      )
                    ),
                    //MARCADORES DOS LOCAIS ESPORTIVOS
                    ...addressController.sportPlaces.map((marker){
                      //RESGATAR POSIÇÕES DO MARKER
                      final point = LatLng(marker['lat'], marker['lon']);
                      //RESGATAR ICONE DO PONTO
                      final icon = addressController.addressService.setMarkerIcon(marker['sport']);
                      final baseSize = addressController.addressService.calculateBaseSize(addressController.currentZoom.value);
                      //VERIFICAR SE LOCAL CONTEM LAT E LONG
                      return Marker(
                        point: point,
                        width: baseSize >= 25 ? baseSize * 2 : baseSize,
                        height: baseSize,
                        rotate: true,
                        child: icon
                      );
                    })
                  ],
                )
              ],
            ],
          );
        }
      }),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatButtonMapWidget(
            floatKey: "search_map",
            icon: Icons.search_rounded,
            onPressed: () => Get.bottomSheet(AddressDialog(), isScrollControlled: true),
          ),
          const SizedBox(height: 30),
          FloatButtonMapWidget(
            floatKey: "position_map",
            icon: Icons.my_location_rounded,
            onPressed: () => addressController.moveMapCurrentUser(LatLng(addressController.currentPosition.value!.latitude, addressController.currentPosition.value!.longitude),),
          ),
        ],
      ),
    );
  }
}