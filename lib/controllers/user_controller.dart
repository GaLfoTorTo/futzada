import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:futzada/helpers/app_helper.dart';
import 'package:futzada/services/address_service.dart';
import 'package:permission_handler/permission_handler.dart';

class UserController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static UserController get instance => Get.find();
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  AddressService addressService = AddressService();
  
  //ESTADOS - POSIÇÃO, ZOOM E CARREGAMENTO DO MAPA
  final RxMap<String, dynamic> currentLocation = <String, dynamic>{}.obs;
  final Rxn<Position> currentPosition = Rxn<Position>();
  final Rxn<LatLng> currentLatLog = Rxn<LatLng>();
  final RxBool hasPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
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
      //DEFINIR POSIÇÃO DO USUARIO
      currentPosition.value = position;
      currentLatLog.value = LatLng(position.latitude, position.longitude);
      currentLocation.value = await addressService.getLatLonLocation(currentLatLog.value!);
      //ARMAZENAR POSIÇÃO DO USUARIO NO GET
      Get.put(currentPosition, tag: 'userPosition', permanent: true);
      Get.put(currentLatLog, tag: 'userLatLog', permanent: true);
      Get.put(currentLocation, tag: 'userLocation', permanent: true);
    } else {
      //CASO PERMISSÃO SEJA NEGADA EXIBIR MENSAGEM DE NECESSIDADE DE PERMISSÃO
      AppHelper.feedbackMessage(Get.context,'Permissão Negada');
    }
  }
}