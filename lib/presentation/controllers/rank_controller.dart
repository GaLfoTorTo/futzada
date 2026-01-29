
//===DEPENDENCIAS BASE===
import 'package:get/get.dart';
import 'package:futzada/data/models/user_model.dart';
import 'package:futzada/data/services/rank_service.dart';
import 'package:futzada/presentation/controllers/event_controller.dart';

abstract class RankBase {
  //GETTER - SERVIÇO DE PARTIDAS
  RankService get rankService;
  //ESTADO - RANKING
  RxString get type;
  //ESTADO - LISTA DE RANKINGS
  RxList<UserModel?> get topRanking;
}

class RankController extends GetxController implements RankBase{
  //GETTER DE CONTROLLERS
  static RankController get instance => Get.find();
  final EventController eventController = EventController.instance;

  //GETTER DE SERVIÇOS
  @override
  RankService rankService = RankService();
  //GETTER DE TYPE
  @override
  RxString type = 'Artilheiros'.obs;
  @override
  late RxList<UserModel> topRanking = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    //topRanking.value = eventController.event.participants!.take(10).toList();
  }
}