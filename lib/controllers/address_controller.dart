import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/services/address_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class AddressController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static AddressController get instance => Get.find();
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  AddressService addressService = AddressService();

  //DEFINIR POSIÇÃO ATUAL DO USUARIO
  final RxMap<String, dynamic> currentLocation = <String, dynamic>{}.obs;
  //DEFINIR POSIÇÃO ATUAL DO USUARIO
  final Rxn<Position> currentPosition = Rxn<Position>();
  //DEFINIR LAT E LONG OBSERVAVEIS
  final Rxn<LatLng> currentLatLog = Rxn<LatLng>();
  //CONTROLLER DO MAPA
  final MapController mapController = MapController();
  //CONTROLADOR DE PESQUISA
  final TextEditingController searchController = TextEditingController();
  //CONTROLLADOR DE CARREGAMENTO DE INFORMAÇÕES
  RxBool isLoaded = false.obs;
  //CONTROLLADOR DE CARREGAMENTO DO MAPA
  RxBool hasPermission = false.obs;
  //CONTROLLADOR DE CARREGAMENTO DO MAPA
  RxBool isMapReady = false.obs;
  //CONTROLLADOR DE PESQUISA DE ENDEREÇOS
  RxBool isSearching = false.obs;
  //DEFINIR TEXTO DE PESQUISA
  RxString searchText = ''.obs;
  //DEFINIR BOUNCE DE CAMPO DE PESQUISA
  late Worker debounceWorker;
  //LISTA DE SUGESTÕES DE ENDEREÇO
  RxList<AddressModel> suggestions = <AddressModel>[].obs;
  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  RxList<Map<String, dynamic>> sportPlaces = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    //RESGATAR POSIÇÃO ATUAL DO USUARIO
    getCurrentLocation();
    //INICIALIZAR O DEBOUNCE
    debounceWorker = debounce(
      searchText,
      (value) => addressService.searchAddress(value),
      time: const Duration(milliseconds: 500),
    );
  }

  //FUNÇÃO PARA BUSCAR LOCALIZAÇÃO DO USUARIO
  Future<void> getCurrentLocation() async {
    //SOLICITAR PERMISSÃO DE ACESSO A LOCALIZAÇÃO
    PermissionStatus permission = await Permission.location.request();
    //ATUALIZAR ESTADO DE PERMISSÃO DE GEOLOCALIZAÇÃO
    hasPermission.value = permission.isGranted;
    //VERIFICAR SE USUARIO CONCEDEU PERMISSÃO
    if (hasPermission.value) {
      //BUSCAR POSIÇÃO ATUAL DO USUARIO
      Position position = await Geolocator.getCurrentPosition();
      //ATUALIZAR STATE
      currentPosition.value = position;
      //DEFINIR LAT E LONG 
      currentLatLog.value = LatLng(position.latitude, position.longitude);
      //CARREGAR DADOS DA LOCALIZAÇÃO ATUAL DO USUÁRIO
      await loadUserLocation(position);
      //CARREGAR LOCAIS ESPOTIVOS
      await loadSportPlaces(position);
    } else {
      //CASO PERMISSÃO SEJA NEGADA EXIBIR MENSAGEM DE NECESSIDADE DE PERMISSÃO
      AppHelper.feedbackMessage(Get.context,'Permissão Negada');
    }
  }

  //FUNÇÃO PARA BUSCAR DADOS DA LOCALIZAÇÃO ATUAL DO USUARIO
  Future<void> loadUserLocation(Position position) async{
    //BUSCAR QUADRAS E CAMPOS
    currentLocation.value = await addressService.getUserLocation(position);
  }

  //FUNÇÃO PARA BUSCAR LOCAIS DE PRATICA DE ESPORTES (QUADRAS CAMPOS)
  Future<void> loadSportPlaces(Position position) async{
    //BUSCAR QUADRAS E CAMPOS
    await addressService.fetchSportCourts(2);
    //ALTERAR ESTADO DE CARREGAMENTO
    isLoaded.value = true;
  }

  //FUNÇÃO PARA MOVER MAPA PARA POSIÇÃO DO USUARIO
  void moveMapCurrentUser(LatLng latLong){
    //MOVER MAPA PARA POSIÇÃO ATUAL DO USUÁRIO
    mapController.move(
      latLong,
      15.0,
    );
  }
}