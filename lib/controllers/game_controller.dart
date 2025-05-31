import 'package:get/get.dart';
import 'package:futzada/models/game_model.dart';
import 'package:futzada/services/game_service.dart';

class GameController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static GameController get instace => Get.find();
  //INSTANCIAR SERVICE DE ENVEOTS
  GameService gameService = GameService();
  //DEFINIR CONTROLADOR DE PARTIDA ATUAL
  GameModel? currentGame;

  @override
  void onInit() {
    super.onInit();
    //RESGATAR JOGO ATUAL
    gameService.getCurrentGame();
  }
}