import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:futzada/core/helpers/app_helper.dart';
import 'package:futzada/data/services/address_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/repositories/event_repository.dart';
import 'package:futzada/data/repositories/user_repository.dart';

class UserController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static UserController get instance => Get.find();
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  UserRepository userRepository = UserRepository();
  EventRepository eventRepository = EventRepository();
  AddressService addressService = AddressService();
  
  //ESTADOS - READY E PERMISSOES
  final RxBool isReady = false.obs;
  final RxBool hasError = false.obs;
  final RxBool hasPermission = false.obs;

  //ESTADOS - POSIÇÃO, ZOOM E CARREGAMENTO DO MAPA
  late UserModel user;
  final RxMap<String, dynamic> currentLocation = <String, dynamic>{}.obs;
  final Rxn<Position> currentPosition = Rxn<Position>();
  final Rxn<LatLng> currentLatLog = Rxn<LatLng>();

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
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

  //FUNÇÃO DE BUSCA DE EVENTOS DO USUARIO
  Future<void> getUserEvents() async{
    //BUSCAR EVENTOS DO USUARIO
    List<EventModel> events = await eventRepository.getUserEvents(user.id);
    if(events.isNotEmpty){
      events[0].date = ["seg",'ter', 'qua', 'qui', 'sex', 'sab', 'dom'];
    }
    //ADICIONAR GLOBALMENT AO GET EVENTOS DO USUARIO
    if (!Get.isRegistered<List<EventModel>>(tag: 'events')) {
      Get.put<List<EventModel>>(
        events,
        tag: 'events',
        permanent: true,
      );
    }
  }

  Future<void> _bootstrap() async {
    try {
      if(Get.isRegistered<UserModel>(tag: 'user')){
        user = Get.find(tag: "user");
        await getCurrentLocation();
        await getUserEvents();
        isReady.value = true;
      }
    } catch (e) {
      hasError.value = true;
      //NAVEGAR PARA LOGIN PAGE
      Get.toNamed('/login');
    }
  }
}