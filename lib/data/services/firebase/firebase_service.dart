import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:futzada/data/services/notification_service.dart';

Future<void> initFirebaseMessaging() async {
  //INSTANCIAR FIREBASE MASSAGING
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // PERMISSÕES DE NOTIFICAÇÃO (ANDROID E IOS)
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // TOKEN DO DISPOSITIVO
  String? token = await messaging
      .getToken()
      .timeout(
        const Duration(seconds: 8),
        onTimeout: () => null,
      );
  
  // ATUALIZAR TOKEN
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("NOVO TOKEN: $newToken");
  });

  // LISTENER DE NOTIFICAÇÃO (APP FECHADO/BACKGROUND)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService().showNotification(message);
  });

  // NAVEGAÇÃO DE NOTIFICAÇÃO (APP ABERTO)
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('Notificação clicada');

    // Exemplo com GetX
    // Get.toNamed(message.data['route']);
  });
}