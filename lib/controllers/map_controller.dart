import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/models/event_model.dart';
import 'package:futzada/services/address_service.dart';
import 'package:futzada/services/event_service.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class MapWidgetController extends GetxController {
  //DEFINIR MODEL DE CHAMANDO DO CONTROLLER
  late String model;
  //DEFINIR CONTROLLER UNICO NO GETX
  static MapWidgetController get instance => Get.find();
  //CONTROLLER DO MAPA
  final MapController mapController = MapController();
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  AddressService addressService = AddressService();
  //INSTANCIAR SERVIÇO DE EVENTOS
  EventService eventService = EventService();
  
  //ESTADOS - POSIÇÃO, ZOOM E CARREGAMENTO DO MAPA
  final RxMap<String, dynamic> currentLocation = <String, dynamic>{}.obs;
  final Rxn<Position> currentPosition = Rxn<Position>();
  final Rxn<LatLng> currentLatLog = Rxn<LatLng>();
  final RxDouble currentZoom = 17.0.obs;
  //CARREGAMENTO
  final RxDouble baseSize = 15.0.obs;
  final RxBool isLoaded = false.obs;
  final RxBool hasPermission = false.obs;
  final RxBool isMapReady = false.obs;
  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  RxList<Map<String, dynamic>> sportPlaces = <Map<String, dynamic>>[].obs;
  //LISTA DE EVENTOS REGISTRADOS
  List<EventModel> events = [];

  @override
  void onInit() {
    super.onInit();
    //RESGATAR MODEL DE CHAMADA DO CONTROLLER DE MAPA
    model = Get.currentRoute.contains('explore') ?  'Explorer' : 'Address';
    //RESGATAR POSIÇÃO ATUAL DO USUARIO
    getCurrentLocation();
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
      await loadSportPlaces(position, model);
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
  Future<void> loadSportPlaces(Position position, String model) async{

    switch (model) {
      case 'Explorer':
        //BUSCAR QUADRAS E CAMPOS
        events.assignAll(/* await */ eventService.getEvents());
      case 'Address':
        //BUSCAR QUADRAS E CAMPOS
        sportPlaces.assignAll(await addressService.getSportPlaces(2));
        break;
      default:
    }
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

  //FUNÇÃO PARA CALCULAR TAMANHO DOS MARKERS 
  double calculateBaseSize() { 
    //AJUSTAR TAMANHO DO ICONE DE ACORDO COM ZOOM 
    if (currentZoom.value > 18) return 40.0; 
    if (currentZoom.value > 16) return 30.0; 
    if (currentZoom.value > 14) return 25.0; 
    if (currentZoom.value > 12) return 20.0; 
    return 15.0; 
  }
}