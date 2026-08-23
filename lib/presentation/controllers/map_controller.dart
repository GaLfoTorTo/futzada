import 'package:flutter/foundation.dart';
import 'package:esportly/core/di/service_locator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:esportly/data/models/event_model.dart';
import 'package:esportly/data/services/address_service.dart';
import 'package:esportly/data/repositories/event_repository.dart';

class MapWidgetController extends ChangeNotifier {
  //DEFINIR MODEL DE CHAMANDA DO CONTROLLER (passado pelo chamador)
  String model;
  //DEFINIR CONTROLLER UNICO NO GETIT
  static MapWidgetController get instance => sl<MapWidgetController>();
  //CONTROLLER DO MAPA
  final MapController mapController = MapController();
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  AddressService addressService = AddressService();
  //INSTANCIAR SERVIÇO DE EVENTOS
  EventRepository eventRepository = EventRepository();

  MapWidgetController({this.model = 'Explorer'});

  //ESTADOS - POSIÇÃO, ZOOM E CARREGAMENTO DO MAPA
  Map<String, dynamic> _currentLocation = sl<Map<String, dynamic>>(instanceName: 'userLocation');
  Map<String, dynamic> get currentLocation => _currentLocation;
  set currentLocation(Map<String, dynamic> v) { _currentLocation = v; notifyListeners(); }

  late Position _currentPosition;
  Position get currentPosition => _currentPosition;
  set currentPosition(Position v) { _currentPosition = v; notifyListeners(); }

  late LatLng _currentLatLog;
  LatLng get currentLatLog => _currentLatLog;
  set currentLatLog(LatLng v) { _currentLatLog = v; notifyListeners(); }

  void _initLocation() {
    if (sl.isRegistered<Position>()) {
      _currentPosition = sl<Position>();
      _currentLatLog = LatLng(_currentPosition.latitude, _currentPosition.longitude);
    } else {
      _currentLatLog = LatLng(0, 0);
    }
  }

  double _currentZoom = 17.0;
  double get currentZoom => _currentZoom;
  set currentZoom(double v) { _currentZoom = v; notifyListeners(); }

  double _baseSize = 15.0;
  double get baseSize => _baseSize;
  set baseSize(double v) { _baseSize = v; notifyListeners(); }

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  set isLoaded(bool v) { _isLoaded = v; notifyListeners(); }

  bool _isMapReady = false;
  bool get isMapReady => _isMapReady;
  set isMapReady(bool v) { _isMapReady = v; notifyListeners(); }

  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  final List<Map<String, dynamic>> _sportPlaces = [];
  List<Map<String, dynamic>> get sportPlaces => _sportPlaces;

  //LISTA DE EVENTOS REGISTRADOS
  final List<EventModel> _events = [];
  List<EventModel> get events => _events;

  void init() {
    _initLocation();
    loadSportPlaces();
  }

  //FUNÇÃO PARA BUSCAR LOCAIS DE PRATICA DE ESPORTES (QUADRAS CAMPOS)
  Future<void> loadSportPlaces() async {
    switch (model) {
      case 'Explorer':
        await Future.delayed(const Duration(seconds: 2));
        final loaded = await eventRepository.getEvents() ?? [];
        _events.clear();
        _events.addAll(loaded);
        isLoaded = true;
        break;
      case 'Address':
        final places = await addressService.getSportPlaces(2);
        _sportPlaces.clear();
        _sportPlaces.addAll(places);
        isLoaded = true;
        break;
      default:
        break;
    }
  }

  //FUNÇÃO PARA MOVER MAPA PARA POSIÇÃO DO USUARIO
  void moveMapCurrentUser(LatLng latLong) {
    mapController.move(latLong, 15.0);
  }

  //FUNÇÃO PARA CALCULAR TAMANHO DOS MARKERS
  double calculateBaseSize() {
    if (currentZoom > 18) return 40.0;
    if (currentZoom > 16) return 30.0;
    if (currentZoom > 14) return 25.0;
    if (currentZoom > 12) return 20.0;
    return 15.0;
  }
}
