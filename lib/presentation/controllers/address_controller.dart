import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/data/services/address_service.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';

class AddressController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETIT
  static AddressController get instance => sl<AddressController>();
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  AddressService addressService = AddressService();

  //CONTROLADOR DE PESQUISA
  final TextEditingController searchController = TextEditingController();
  //DEBOUNCE TIMER
  Timer? _debounceTimer;

  //CONTROLLADOR DE PESQUISA DE ENDEREÇOS
  bool _isSearching = false;
  bool get isSearching => _isSearching;
  set isSearching(bool v) { _isSearching = v; notifyListeners(); }

  //DEFINIR TEXTO DE PESQUISA
  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String v) {
    _searchText = v;
    notifyListeners();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      addressService.searchAddress(v);
    });
  }

  //DEFINIR CATEGORIA
  String _category = '';
  String get category => _category;
  set category(String v) { _category = v; notifyListeners(); }

  //LISTA DE SUGESTÕES DE ENDEREÇO
  final List<AddressModel> _suggestions = [];
  List<AddressModel> get suggestions => _suggestions;

  void setSuggestions(List<AddressModel> list) {
    _suggestions.clear();
    _suggestions.addAll(list);
    notifyListeners();
  }

  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  final List<Map<String, dynamic>> _sportPlaces = [];
  List<Map<String, dynamic>> get sportPlaces => _sportPlaces;

  void init() {}

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  //FUNÇÃO PARA BUSCAR MARKER NO ARRAY
  bool getMarkerByArray(AddressModel suggestion) {
    return _sportPlaces.any((item) {
      if (item['address'] != null) {
        final address = item['address'] as AddressModel;
        return suggestion.street!.contains(address.street!) && suggestion.city!.contains(address.city!);
      }
      return false;
    });
  }

  //FUNÇÃO PARA DEFINIR ENDEREÇO DO EVENTO
  void setEventAddress(AddressModel? suggestion) {
    //FECHAR DIALOG
    sl<GoRouter>().pop();
    //VERIFICAR SE SUGESTÃO NÃO ESTA VAZIA
    if (suggestion != null) {
      //DEFINIR TEXTO DO INPUT DE ENDEREÇO
      eventController.addressText = "${suggestion.street ?? ''} ${suggestion.borough ?? ''}, ${suggestion.number ?? ''} - ${suggestion.borough ?? ''} - ${suggestion.city}/${suggestion.state}";
      //ATUALIZAR ENDEREÇO DA PELADA
      eventController.addressEvent = suggestion;
      //ATUALIZAR CATEGORIA APARTIR DO ENDEREÇO
      eventController.category = category;
      //LIMPAR SUGESTÕES E CAMPO DE PESQUISA
      _suggestions.clear();
      searchController.clear();
      notifyListeners();
      //NAVEGAR DE VOLTA PARA TELA DE REGISTRO DE ENDEREÇOS
      sl<GoRouter>().go('/event/register/address');
    }
  }

  //FUNÇÃO PARA DEFINIR A CATEGORIA A PARTIR DA SUPERFICIE
  void setCategory(marker) {
    //VERIFICAR ESPORTE
    if (marker['sport'] == "soccer" || marker['sport'] == "football" || marker['sport'] == "futebol") {
      switch (marker['surface']) {
        case "grass":
        case "sand":
          category = "Futebol";
          break;
        case "artificial_turf":
          category = "Fut7";
          break;
        default:
          category = "Futsal";
          break;
      }
    } else {
      category = "Futsal";
    }
  }
}
