import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:futzada/data/models/address_model.dart';
import 'package:futzada/data/services/address_service.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';

class AddressController extends GetxController{
  //DEFINIR CONTROLLER UNICO NO GETX
  static AddressController get instance => Get.find();
  //RESGATAR CONTROLLER DE EVENTO
  EventController eventController = EventController.instance;
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  AddressService addressService = AddressService();

  //CONTROLADOR DE PESQUISA
  final TextEditingController searchController = TextEditingController();
  //CONTROLLADOR DE PESQUISA DE ENDEREÇOS
  RxBool isSearching = false.obs;
  //DEFINIR TEXTO DE PESQUISA
  RxString searchText = ''.obs;
  //DEFINIR CATEGORIA
  RxString category = ''.obs;
  //DEFINIR BOUNCE DE CAMPO DE PESQUISA
  late Worker debounceWorker;
  //LISTA DE SUGESTÕES DE ENDEREÇO
  RxList<AddressModel> suggestions = <AddressModel>[].obs;
  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  RxList<Map<String, dynamic>> sportPlaces = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
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
    //FECHAR DIALOG
    Get.back();
    //VERIFICAR SE SUGESTÃO NÃO ESTA VAZIA
    if(suggestion != null){
      //DEFINIR TEXTO DO INPUT DE ENDEREÇO
      eventController.addressText.value = "${suggestion.street ?? ''} ${suggestion.borough ?? ''}, ${suggestion.number ?? ''} - ${suggestion.borough ?? ''} - ${suggestion.city}/${suggestion.state}";
      //ATUALIZAR ENDEREÇO DA PELADA
      eventController.addressEvent = suggestion;
      //ATUALIZAR CATEGORIA APARTIR DO ENDEREÇO
      eventController.category = category;
      //LIMPAR SUGESTÕES E CAMPO DE PESQUISA
      suggestions.clear();
      searchController.clear();
      //NAVEGAR DE VOLTA PARA TELA DE REGISTRO DE ENDEREÇOS
      Get.offNamed('/event/register/address');
    }
  }

  //FUNÇÃO PARA DEFINIR A CATEGORIA A PARTIR DA SUPERFICIE
  void setCategory(marker){
    //VERIFICAR ESPORTE
    if(marker['sport'] == "soccer" || marker['sport'] == "football" || marker['sport'] == "futebol"){
      switch (marker['surface']) {
        case "grass":
        case "sand":
          category.value = "Futebol";
          break;
        case "artificial_turf":
          category.value = "Fut7";
          break;
        default:
          category.value = "Futsal";
          break;
      }
    }else{
      category.value = "Futsal";
    }
  }
}