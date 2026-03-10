import 'package:get/get.dart';
import 'package:futzada/data/models/event_model.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/repositories/event_repository.dart';
import 'package:futzada/data/repositories/user_repository.dart';

class ProfileController extends GetxController {
  ProfileController();

  //DEFINIR CONTROLLER UNICO NO GETX
  static ProfileController get instance => Get.find();
  //INSTANCIAR SERVIÇO DE ENDEREÇOS
  UserRepository userRepository = UserRepository();
  EventRepository eventRepository = EventRepository();
  
  //ESTADOS - READY E PERMISSOES
  final RxBool isLoaded = false.obs;
  final RxBool isReady = false.obs;
  final RxBool hasError = false.obs;
  final RxBool hasPermission = false.obs;

  //ESTADOS - POSIÇÃO, ZOOM E CARREGAMENTO DO MAPA
  late UserModel user;
  List<EventModel> events = [];

  Future<void> getProfile(id) async{
    Future.delayed(const Duration(milliseconds: 1000));
    await getUser(id);
    await getUserEvents();
    isLoaded.value = true;
  }

  //FUNÇÃO PARA BUSCAR DADOS DO USUARIO
  Future<void> getUser(id) async{
    Future.delayed(const Duration(milliseconds: 1000));
    user = await userRepository.getUser(id);
  }

  //FUNÇÃO DE BUSCA DE EVENTOS DO USUARIO
  Future<void> getUserEvents() async{
    //BUSCAR EVENTOS DO USUARIO
    events.addAll(await eventRepository.getUserEvents(user.id));
  }
}