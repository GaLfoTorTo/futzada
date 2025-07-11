import 'package:get/get.dart';
import 'package:dio/dio.dart'as Dio;
import 'package:futzada/api/api.dart';
import 'package:latlong2/latlong.dart';
import 'package:futzada/models/address_model.dart';
import 'package:futzada/controllers/address_controller.dart';

class AddressService {
  //BUSCAR DADOS DA LOCALIZAÇÃODO USUARIO LOGADO
  Future<Map<String, dynamic>> getLatLonLocation(LatLng latLon) async {
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //RESGATAR LAT E LONG DO USUÁRIO
      final lat = latLon.latitude;
      final long = latLon.longitude;
      //BUSCAR CIDADE DO USUARIO
      final response = await dio.get(
        AppApi.mapReverse,
        queryParameters: {
          'lat': lat,
          'lon': long,
          'format': 'json',
          'addressdetails': 1,
        },
        options: Dio.Options(
          headers: {'User-Agent': 'futzada-app/1.0 (futzada@futzada.com)'},
        ),
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if (response.statusCode == 200) {
        //RESGATAR DADOS DE ENDEREÇO DO USUÁRIO
        return response.data['address'];
      }
      return {};
    } catch (e) {
      print('Erro ao obter cidade/estado: $e');
      return {};
    }
  }

  //FUNÇÃO PARA BUSCAR QUADRAS POLIESPORTIVAS 
  Future<void> getSportPlaces(double radiusKm) async {
    //RESGATAR CONTROLLER DE ENDEREÇOS
    AddressController addressController = AddressController.instance;
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //RESGATAR DADOS DE LOCALIZAÇÃO DO USUÁRIO
      final state = addressController.currentLocation['state'] ?? '';
      //CONSULTA POR ESTADO
      final query = """
        [out:json];
        //DEFINIR AREA DE BUSCA
        area[name="$state"];
        //DEFINIR ITENS DE BUSCA
        (
          nwr[leisure="pitch"]["sport"~"^(multi|soccer|football|futebol|basquete|basketball|volei|volleyball)\$"](area);
        );
        out center tags;
      """;
      //BUSCAR CIDADE DO USUARIO
      final response = await dio.post(
        AppApi.mapInterpreter,
        data: query
      );
      //VERIFICAR SE CONSULTA FOI BEM SUCEDIDA
      if (response.statusCode == 200) {
        //CONVERTER E FILTRAR DADOS RECEBIDOS
        final List<Map<String, dynamic>> list = (response.data['elements'] as List)
          .where((element) => element != null)
          .map((item) {
            //TIPANDO ITEM DE RESPOSTA
            final map = Map<String, dynamic>.from(item as Map);
            //GERAR MAPA DE MARKER
            return setMarker(map);
          })
          .whereType<Map<String, dynamic>>()
          .toList();
        //ATUALIZAR LISTA DE LOCAIS
        addressController.sportPlaces.assignAll(list);
      }
    } catch (e) {
      print("erro: $e");
    }
  }
  
  //FUNÇÃO PARA CRIAÇÃO DE MARKER DE MAPA
  Map<String, dynamic> setMarker(Map<String, dynamic> place) {
    //VERIFICAR SE LOCAL CONTEM TAGS
    final tags = place['tags'] ?? {};
    //RETORNAR MAP DE MARKER
    return {
      "id": place['id']?.toString() ?? '',
      "lat": place['lat'] ?? place['center']?['lat'],
      "lon": place['lon'] ?? place['center']?['lon'],
      "name": tags['name']?.toString() ?? null,
      "sport": setSportType(tags),
      "surface": setSurface(tags['surface']?.toString()),
      "access": setAccess(tags['access']?.toString()),
      "address": null
    };
  }

  //FUNÇÃO PARA RESGATAR TIPO DE ESPORTE DO LOCAL
  String setSportType(Map<String, dynamic>? place){
    //RETORNAR VALOR PADRÃO MULTI CASO VALOR RECEBIDO SEJA NULL
    if (place == null) return "Multi";
    //DEFINIR VALOR DE MULTI
    final sport = place['sport']?.toString().toLowerCase() ?? 'multi';
    //VERIFICAR SE LOCAL COMPORTA MAIS DE 1 ESPORTE E RETORNAR MULTI
    if (place.containsKey('sport_1')) return "Multi";
    //VERIFICAR VALORES DE ESPORTE
    switch (sport) {
      //VALORES DE FUTEBOL/FUT7/FUTSAL
      case "soccer":
      case "football":
      case "futebol":
        final surface = setSurface(place['surface']?.toString());
        if (surface == "Concreto" || surface == "Asfalto") return "Futsal";
        if (surface == "Areia") return "Futebol de Areia";
        if (surface == "Grama Sintética") return "Fut7";
        return "Futebol";
      //VALORES DE VOLEI 
      case "volei":
      case "volleyball":
        return setSurface(place['surface']?.toString()) == "Areia" 
            ? "Volei de Praia" 
            : "Volei";
      //VALORES DE BASQUETE
      case "basquete":
      case "basketball":
        return "Basquete";
      //VALORES DE MULTI  
      default:
        return "Multi";
    }
  }

  //FUNÇÃO PARA TRADUÇÃO DE SUPERFICIES DE LOCAIS
  String setSurface(String? surfaceKey) {
    //DEFINIR VALOR PADRÃO
    final surface = surfaceKey?.toLowerCase() ?? 'concrete';
    //VERIFICAR SUPERFICIE DO LOVAL
    switch (surface) {
      case 'grass': return 'Grama';
      case 'artificial_turf': return 'Grama Sintética';
      case 'wood': return 'Madeira';
      case 'sand': return 'Areia';
      case 'earth':
      case 'clay': return 'Terra';
      default: return 'Concreto';
    }
  }

  //FUNÇÃO PARA DEFINIR ACESSO AO LOCAL
  String setAccess(String? access){
    //VERIFICAR SE LOCAL CONTEM ACESSO DEFINIDO 
    final accessType = access?.toLowerCase() ?? 'public'; // Valor padrão
    return accessType == 'private' || accessType == 'no' ? 'Privado' : 'Publico';
  }

  //FUNÇÃO DE BUSCA DE ENDEREÇOS
  Future<void> searchAddress(String address) async {
    //RESGATAR CONTROLLER DE ENDEREÇOS
    AddressController addressController = AddressController.instance;
    //DEFINIR ESTADO DE PSEQUISA COMO TRUE
    addressController.isSearching.value = true;
    //LIMPAR SUGESTÕES
    addressController.suggestions.clear();
    //RESGATAR CIDADE DO USUÁRIO
    final state = addressController.currentLocation['state'] ?? '';
    //TENTAR ENVIAR DADOS
    try {
      //INSTANCIAR DIO
      var dio = Dio.Dio();
      //INICIALIZAR REQUISIÇÃO
      var response = await dio.get(
        AppApi.mapSearch, 
        queryParameters: {
          'q': '$address, $state',
          'format': 'json',
          'addressdetails': 1,
          'countrycodes':'br',
          'accept-language': 'br'
        },
        options: Dio.Options(
          headers: {
            'User-Agent': 'futzada-app/1.0 (futzada@futzada.com)'
          }
        ),
      );
      //VERIFICAR RESPOSTA DO SERVIDOR
      if(response.statusCode == 200 && response.data != null) {
        //MONTAR MAP DE SUGESTÕES
        final resp = response.data.map<AddressModel>((item){
          //GERAR ENDEREÇO
          return AddressModel.fromMap({
            'street' : "${item['address']['road'] ?? ''} ${item['address']['county'] ?? ''}",
            'number' : item['address']['house_number'],
            'suburb' : item['address']['suburb'],
            'borough' : item['address']['borough'],
            'city' : item['address']['city'],
            'state' : item['address']['state'],
            'country' : item['address']['country_code'],
            'zipCode' : item['address']['postcode'],
            'latitude' : double.parse(item['lat']),
            'longitude' : double.parse(item['lon']),
          });
        });
        //ATUALIZAR A LISTA DE SUGESTÕES
        addressController.suggestions.assignAll(resp);
        addressController.update();
      }
    } catch (e) {
      //TRATAR ERROS
      print(e);
    }
    //DEFINIR ESTADO DE PSEQUISA COMO TRUE
    addressController.isSearching.value = false;
    return;
  }
}