import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/theme/app_animations.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/theme/app_colors.dart';
import 'package:futzada/widget/bars/header_widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart' as lottie;
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({
    super.key,
  });

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  //POSIÇÃO DO USUARIO
  Position? currentPosition;
  //CONTROLLER DO MAPA
  final MapController mapController = MapController();
  //CONTROLLADOR DE CARREGAMENTO DO MAPA
  bool isMapReady = false;

  @override
  void initState() {
    super.initState();
  }

  //FUNÇÃO PARA BUSCAR POSIÇÃO DO USUARIO
  Future<void> getCurrentLocation() async {
    //SOLICITAR PERMISSÃO DE ACESSO A LOCALIZAÇÃO
    PermissionStatus permission = await Permission.location.request();
    //VERIFICAR SE USUARIO CONCEDEU PERMISSÃO
    if (permission.isGranted) {
      //BUSCAR LOCALIZAÇÃO ATUAL DO USUARIO
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        //ATUALIZAR STATE
        currentPosition = position;
        //VERIFICAR SE MAPA FOI CARREGADO
        if(isMapReady){
          moveMapCurrentUser();
        }
      });
    } else {
      //CASO PERMISSÃO SEJA NEGADA EXIBIR MENSAGEM DE NECESSIDADE DE PERMISSÃO
      AppHelper.erroMessage(context, 'Permissão Negada');
    }
  }

  //FUNÇÃO PARA MOVER MAPA PARA POSIÇÃO DO USUARIO
  void moveMapCurrentUser(){
    //VERIFICAR SE POSIÇÃO ATUAL DO USUÁRIO NÃO ESTA VAZIA
    if(currentPosition != null){
      //MOVER MAPA PARA POSIÇÃO ATUAL DO USUÁRIO
      mapController.move(
        LatLng(currentPosition!.latitude, currentPosition!.longitude),
        15.0,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light,
      appBar: HeaderWidget(
        title: "Mapa", 
        leftAction: () => Get.back(),
      ),
      body: Stack(
        children: [
          if (!isMapReady)
            Center(
              child: lottie.Lottie.asset(
                AppAnimations.loading,
                fit: BoxFit.contain,
              ),
            ),
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: currentPosition != null 
                  ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
                  : LatLng(0, 0),
              initialZoom: 13.0,
              onMapReady: () {
                setState(() {
                  isMapReady = true;
                  //BUSCAR LOCALIZAÇÃO ATUAL DO USUARIO E AJUSTAR MAPA
                  getCurrentLocation();
                });
              }
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.futzada.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentPosition != null 
                    ? LatLng(currentPosition!.latitude, currentPosition!.longitude)
                    : LatLng(0, 0),
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ]
      ),
    );
  }
}
