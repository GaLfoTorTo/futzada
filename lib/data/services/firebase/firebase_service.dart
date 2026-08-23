import 'package:esportly/data/models/event_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:esportly/data/services/notification_service.dart';

class FirebaseService {

  //FUNÇÃO DE INICIALIZAÇÃO DE NOTIFICAÇÕES (FIREBASE)
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
    await messaging
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

    });
  }

  //FUNÇÃO DE SUBSCRIÇÃO EM CANAL TOPIC (NOTIFICAÇÕES FMC)
  Future<void> subscribe(List<EventModel> events) async {
    if(events.isEmpty) return;
    //SUBSCREVER EM CANAL DE NOTIFICAÇÕES
    for (final event in events) {
      final topic = 'event_${event.uuid?.replaceAll('-', '_')}';
      await FirebaseMessaging.instance.subscribeToTopic(topic);
    }
  }

  //FUNÇÃO DE UNSUBSCRIÇÃO EM CANAL TOPIC (NOTIFICAÇÕES FMC)
  Future<void> unsuscribe(EventModel event) async {
    final topic = 'event_${event.uuid?.replaceAll('-', '_')}';
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }
}
