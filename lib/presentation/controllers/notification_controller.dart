import 'package:flutter/foundation.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/data/services/notification_service.dart';

class NotificationController extends ChangeNotifier {
  //DEFINIR CONTROLLER UNICO NO GETX
  static NotificationController get instace => sl<NotificationController>();
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