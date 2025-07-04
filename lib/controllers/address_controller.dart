import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futzada/controllers/event_controller.dart';
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
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
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

  //FUNÇÃO PARA BUSCAR MARKER NO ARRAY
  bool getMarkerByArray(AddressModel suggestion) {
    //TENTAR ENCONTRAR MARKER CORRESPONDETE A SUGESTÃO SELECIONADA
    return sportPlaces.any((item) {
      //VERIFICAR SE ITEM CONTEM ENDEREÇO DEFINIDO
      if (item['address'] != null) {
        final address = item['address'] as AddressModel;
        //VERIFICAR COMPATIBILIDADE DE ENDEREÇO
        return suggestion.street!.contains(address.street!) && suggestion.city!.contains(address.city!);
      }
      return false;
    });
  }

  //FUNÇÃO PARA DEFINIR ENDEREÇO DO EVENTO
  void setEventAddress(AddressModel? suggestion){
    print(suggestion);
    //FECHAR DIALOG
    Get.back();
    //VERIFICAR SE SUGESTÃO NÃO ESTA VAZIA
    if(suggestion != null){
      //DEFINIR TEXTO DO INPUT DE ENDEREÇO
      eventController.addressText.value = "${suggestion.street ?? ''} ${suggestion.borough ?? ''}, ${suggestion.number ?? ''} - ${suggestion.borough ?? ''} - ${suggestion.city}/${suggestion.state}";
      //ATUALIZAR ENDEREÇO DA PELADA
      eventController.addressEvent = suggestion;
      //ATUALIZAR E MOVER MAPAR PARA LAT E LONG RECEBIDA
      moveMapCurrentUser(LatLng(suggestion.latitude!, suggestion.longitude!));
      //LIMPAR SUGESTÕES E CAMPO DE PESQUISA
      suggestions.clear();
      searchController.clear();
      //NAVEGAR DE VOLTA PARA TELA DE REGISTRO DE ENDEREÇOS
      Get.offNamed('/event/register/address');
    }
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
    //RESGATAR LAT E LON DA POSIÇÃO RECEBIDA
    final latlon = LatLng(position.latitude, position.longitude);
    //BUSCAR QUADRAS E CAMPOS
    currentLocation.value = await addressService.getLatLonLocation(latlon);
  }

  //FUNÇÃO PARA BUSCAR LOCAIS DE PRATICA DE ESPORTES (QUADRAS CAMPOS)
  Future<void> loadSportPlaces(Position position) async{
    //BUSCAR QUADRAS E CAMPOS
    await addressService.getSportPlaces(2);
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