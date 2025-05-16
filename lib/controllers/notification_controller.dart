import 'package:futzada/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  //DEFINIR CONTROLLER UNICO NO GETX
  static NotificationController get instace => Get.find();
  //INICIALIZAR SERVICE
  final NotificationService notificationService = NotificationService();

  //FUNÇÃO PARA OBTER AS NOTIFICAÇÕES
  List<Map<String, dynamic>> getNotifications(String type) {
    if (type == 'all') {
      return notificationService.generateNotifications(); 
    }else{
      return notificationService.generateNotifications();
    }
  }
}