import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/services/address_service.dart';
import 'package:futzada/data/repositories/event_repository.dart';

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
  EventRepository eventRepository = EventRepository();
  
  //ESTADOS - POSIÇÃO, ZOOM E CARREGAMENTO DO MAPA
  final RxMap<String, dynamic> currentLocation = Get.find(tag: 'userLocation');
  final Rxn<Position> currentPosition = Get.find(tag: 'userPosition');
  final Rxn<LatLng> currentLatLog = Get.find(tag: 'userLatLog');
  final RxDouble currentZoom = 17.0.obs;
  //CARREGAMENTO
  final RxDouble baseSize = 15.0.obs;
  final RxBool isLoaded = false.obs;
  final RxBool isMapReady = false.obs;
  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  RxList<Map<String, dynamic>> sportPlaces = <Map<String, dynamic>>[].obs;
  //LISTA DE EVENTOS REGISTRADOS
  RxList<EventModel> events = <EventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    //RESGATAR MODEL DE CHAMADA DO CONTROLLER DE MAPA
    model = Get.currentRoute.contains('explore') ?  'Explorer' : 'Address';
    //RESGATAR EVENTOS OU LOCAIS DE PRATICAS DE EXPORTE
    loadSportPlaces();
  }

  //FUNÇÃO PARA BUSCAR LOCAIS DE PRATICA DE ESPORTES (QUADRAS CAMPOS)
  Future<void> loadSportPlaces() async{
    //VERIFICAR SE POSIÇÃO DO USUÁRIO FOI RESGATADA
    if(currentPosition.value != null) {
      //BUSCAR EVENTOS OU LOCAIS APARTIR DA MODEL DEFINIDA
      switch (model) {
        case 'Explorer':
          await Future.delayed(const Duration(seconds: 2));
          //BUSCAR QUADRAS E CAMPOS
          events.assignAll(await eventRepository.getEvents() ?? []);
          isLoaded.value = true;
        case 'Address':
          //BUSCAR QUADRAS E CAMPOS
          sportPlaces.assignAll(await addressService.getSportPlaces(2));
          isLoaded.value = true;
          break;
        default:
      }
    }else{
      isLoaded.value = false;
      //CASO PERMISSÃO SEJA NEGADA EXIBIR MENSAGEM DE NECESSIDADE DE PERMISSÃO
      AppHelper.feedbackMessage(Get.context,'Não foi possível acessar a posição do usuário');
    }
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