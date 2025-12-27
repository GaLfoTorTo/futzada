import 'package:get/get.dart';

class ExplorerController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static ExplorerController get instance => Get.find();
  //LISTA DE ENDEREÇO DE QUADRAS/CAMPOS PUBLICOS E PRIVADOS
  RxList<Map<String, dynamic>> sportPlaces = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
  }
}
