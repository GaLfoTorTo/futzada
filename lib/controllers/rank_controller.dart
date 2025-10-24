
//===DEPENDENCIAS BASE===
import 'package:futzada/controllers/event_controller.dart';
import 'package:futzada/models/participant_model.dart';
import 'package:futzada/services/rank_service.dart';
import 'package:get/get.dart';

abstract class RankBase {
  //GETTER - SERVIÇO DE PARTIDAS
  RankService get rankService;
  //ESTADO - RANKING
  RxString get type;
  //ESTADO - LISTA DE RANKINGS
  RxList<ParticipantModel?> get topRanking;
}

class RankController extends GetxController implements RankBase{
  //GETTER DE CONTROLLERS
  static RankController get instance => Get.find();
  final EventController eventController = EventController.instance;

  //GETTER DE SERVIÇOS
  @override
  RankService rankService = RankService();
  @override
  RxString type = 'Artilheiros'.obs;
  @override
  late RxList<ParticipantModel?> topRanking = <ParticipantModel?>[].obs;

  @override
  void onInit() {
    super.onInit();
    //topRanking.value = eventController.event.participants!.take(10).toList();
  }
}