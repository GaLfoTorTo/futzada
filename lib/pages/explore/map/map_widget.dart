import 'package:get/get.dart';
import 'package:futzada/api/api.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futzada/controllers/map_controller.dart';
import 'package:futzada/pages/erros/erro_permission_page.dart';
import 'package:futzada/widget/markers/user_marker_widget.dart';
import 'package:futzada/widget/markers/sport_cluster_widget.dart';
import 'package:futzada/widget/markers/event_cluster_widget.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  //CONTROLLER DO MAPA (CUSTOM)
  final MapWidgetController mapWidgetController = MapWidgetController.instance;
  //RESGATAR ROTA ATUAL
  String route = Get.currentRoute;
  
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapWidgetController.mapController,
      options: MapOptions(
        initialCenter: mapWidgetController.currentLatLog.value!,
        initialZoom: mapWidgetController.currentZoom.value,
        maxZoom: 18.0,
        minZoom: 12.0,
        onMapEvent: (mapEvent) async{
          //ATUALIZAR ZOOM DE CAMERA E TAMANHO DOS ITENS NO MAPA
          mapWidgetController.currentZoom.value = mapEvent.camera.zoom;
          mapWidgetController.baseSize.value = mapWidgetController.calculateBaseSize();
          setState(() {});
        },
        onMapReady: () async{
          //ESPERAR 2 SEGUNDOS
          await Future.delayed(const Duration(seconds: 2));
          //ESTADOS - MAPA E CARREGAMENTO
          mapWidgetController.isMapReady.value = true;
          //MOVER MAPA PARA POSIÇÃO ATUAL DO USUÁRIO
          mapWidgetController.moveMapCurrentUser(LatLng(
            mapWidgetController.currentPosition.value!.latitude, 
            mapWidgetController.currentPosition.value!.longitude)
          );
        }
      ),
      children: [
        //EXIBIR MENSAGEM E BOTÃO DE SOLICITAÇÃO DE PERMISSÃO PARA GEOLOCALIZAÇÃO
        if(!mapWidgetController.isLoaded.value && mapWidgetController.isMapReady.value)...[
          const ErroPermissionPage()
        ]else...[
          TileLayer(
            urlTemplate: AppApi.map,
            subdomains: const ['a', 'b', 'c', 'd'],
          ),
          //POSIÇÃO ATUAL DO USUARIO
          const UserMarkerWidget(),
          //MARKERS (EVENTOS, SPORT PLACE)
          if(route.contains('explore'))...[
            //CLUSTERIZAÇÃO DE MARKERS (EVENTOS)
            EventClusterWidget( events: mapWidgetController.events)
          ]else...[
            //CLUSTERIZAÇÃO DE MARKERS (SPORT)
            SportClusterWidget(sportPlaces: mapWidgetController.sportPlaces)
          ]
        ],
      ],
    );
  }
}
