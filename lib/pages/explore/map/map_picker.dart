import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:futzada/theme/app_icones.dart';
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
  //CONTROLADOR DE ZOOM DO MAPA
  RxDouble currentZoom = 17.0.obs;
  //ITENS DE RENDERIZAÇÃO DE MARKER
  RxDouble baseSize = 15.0.obs;
  late double iconSize;
  late double borderWidth;
  late double borderRadius;

  @override
  void initState() {
    super.initState();
    //INICIALIZAR CONTROLLER DE ENDEREÇOS
    addressController = Get.put(AddressController());
    //INICIALIZAR TAMANHO DO ICONE
    setItensMarker();
    //LISTENER DE EVENTOS DO MAPA 
    addressController.mapController.mapEventStream.listen((event) {
      if (event is MapEventMove) {
        //ATUALIZAR ZOOM DE CAMERA E TAMANHO DOS ITENS NO MAPA
        currentZoom.value = event.camera.zoom;
        baseSize.value = calculateBaseSize(currentZoom.value);
        //ATUALIZAR VALOR DE ITENS DO MARKERS
        setItensMarker();
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

  //AJUSTAR ITENS DO MARKER
  void setItensMarker(){
    //VERIFICAR ZOOM ATUAL
    if(currentZoom.value < 16){
      iconSize = baseSize.value * 0.6;
      borderWidth = 2.0;
      borderRadius = baseSize.value / 2;
    }else{
      iconSize = baseSize.value * 0.6;
      borderWidth = 1.0;
      borderRadius = baseSize.value * 0.40;
    }
  }

  //FUNÇÃO PARA DEFINBIR ICONE DO MARKER DO MAPA
  Widget setMarkerIcon(String sport){
    //DEFINIR ICONE E COR PADRÃO
    var color = AppColors.gray_300;
    var icon = AppIcones.modality_solid;

    switch (sport) {
      case 'Futsal':
      case 'Fut7':
      case 'Futebol':
        //DEFINIR COR E ICONE PARA TIPO FUTEBOL
        color = AppColors.green_300;
        icon = AppIcones.futebol_ball_solid;
      case 'Basquete':
        //DEFINIR COR E ICONE PARA TIPO BASQUETE
        color = AppColors.orange_300;
        icon = AppIcones.basquete_ball_solid;
      case 'Volei':
      case 'Volei de Praia':
        //DEFINIR COR E ICONE PARA TIPO VOLEI
        color = sport == "Volei" ? AppColors.yellow_300 : AppColors.bege_300;
        icon = AppIcones.volei_ball_solid;
    }
    //RETORNAR WIDGET
    return InkWell(
      onTap: (){
        //ABRIR BOTTOMSHEET DO LOCAL
        //BUSCAR INFORMAÇÕES DO LOCAL PELO ID
        print('testes');
      },
      child: Container(
        width: currentZoom.value >= 15 ? baseSize.value * 2 : baseSize.value,
        height: baseSize.value,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.white, width: borderWidth)
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: AppColors.blue_500,
        )
      ),
    );
  }

  //FUNÇÃO PARA RESGATAR COR DE ESPORTE PREDOMINANTE
  Color getColorSport(List<Marker> markers){
    //CONTADORES DE ESPORTE PREDOMINANTE
    final sportCounts = {};
    //FILTRAR KEYS DA LISTA DE MARKERS
    markers.map((m) => m.key.toString()).forEach((sport) {
      var key = sport.replaceFirst("[<'",'').replaceFirst(">]'",'').split("_id")[0];
      sportCounts[key] = (sportCounts[key] ?? 0) + 1;
    });
    //REDUCE DE ESPORTES DOMINANTES
    final dominantSport = sportCounts.entries
      .reduce((a, b) => a.value >= b.value ? a : b)
      .key;

    //RESGATAR COR DO ESPORTE DOMINANTE
    switch (dominantSport) {
      case 'Futebol':
      case "Fut7":
      case "Futsal":
        return  AppColors.green_300;
      case 'Basquete':
        return AppColors.orange_300;
      case 'Volei':
        return AppColors.yellow_300;
      case 'Volei de Praia':
        return AppColors.bege_300;
      default:
        return  AppColors.gray_300;
    };
  }
  
  //FUNÇÃO PARA CALCULAR TAMANHO DOS MARKERS
  double calculateBaseSize(double zoom) {
    //AJUSTAR TAMANHO DO ICONE DE ACORDO COM ZOOM
    if (zoom > 18) return 40.0;
    if (zoom > 16) return 30.0;
    if (zoom > 14) return 25.0;
    if (zoom > 12) return 20.0;
    return 15.0;
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
              initialZoom: currentZoom.value,
              maxZoom: 18.0,
              minZoom: 12.0,
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
                  ],
                ),
                if (baseSize.value <= 25)...[
                  //CLUSTERIZAÇÃO DE MARKERS
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 100,
                      size: const Size(40, 40),
                      markers: addressController.sportPlaces.map((marker) {
                        return Marker(
                          point: LatLng(marker['lat'], marker['lon']),
                          width: baseSize.value,
                          height: baseSize.value,
                          child: setMarkerIcon(marker['sport']),
                          key: ValueKey("${marker['sport']}_id${marker['id']}")
                        );
                      }).toList(),
                      builder: (context, markers) {
                        final color = getColorSport(markers);
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: color,
                          ),
                          child: const Icon(
                            AppIcones.modality_solid,
                            size: 25,
                            color: AppColors.blue_500,
                          )
                        );
                      },
                      disableClusteringAtZoom: 14,
                    ),
                  )
                ]else...[
                  MarkerLayer(
                    //MARCADORES DOS LOCAIS ESPORTIVOS
                    markers: addressController.sportPlaces.map((marker){
                      //RESGATAR POSIÇÕES DO MARKER
                      final point = LatLng(marker['lat'], marker['lon']);
                      //RESGATAR ICONE DO PONTO
                      final icon = setMarkerIcon(marker['sport']);
                      //VERIFICAR SE LOCAL CONTEM LAT E LONG
                      return Marker(
                        point: point,
                        width: baseSize.value >= 25 ? baseSize.value * 2 : baseSize.value,
                        height: baseSize.value,
                        rotate: true,
                        child: icon
                      );
                    }).toList()
                  )
                ]
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