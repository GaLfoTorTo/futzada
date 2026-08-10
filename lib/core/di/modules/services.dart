import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:futzada/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/core/api/api_client.dart';
import 'package:futzada/data/services/user_service.dart';
import 'package:futzada/data/services/event_service.dart';
import 'package:futzada/data/services/firebase/firebase_service.dart';
import 'package:futzada/data/services/timer_service.dart';

//FUNÇÃO DE INICIALIZAÇÃO DE SERVIÇOS GLOBAIS — chamada no início do app
void registerServices(ProviderContainer container) {
  sl.registerSingleton<GoRouter>(AppRoutes.createRouter(container));
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<UserService>(() => UserService());
  sl.registerLazySingleton<EventService>(() => EventService());
  sl.registerLazySingleton<TimerService>(() => TimerService());
}

//INICIALIZAÇÃO DO FIREBASE MESSAGING — chamada separadamente
Future<void> initFirebaseMessaging() async {
  await FirebaseService().initFirebaseMessaging();
}