import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/presentation/controllers/app_controller.dart';
import 'package:esportly/presentation/controllers/auth_controller.dart';
import 'package:esportly/presentation/controllers/navigation_controller.dart';
import 'package:esportly/presentation/controllers/theme_controller.dart';
import 'package:esportly/presentation/controllers/showcase_controller.dart';
import 'package:esportly/presentation/controllers/user_controller.dart';
import 'package:esportly/presentation/controllers/home_controller.dart';
import 'package:esportly/presentation/controllers/event_controller.dart';
import 'package:esportly/presentation/controllers/rank_controller.dart';
import 'package:esportly/presentation/controllers/explorer_controller.dart';
import 'package:esportly/presentation/controllers/chat_controller.dart';
import 'package:esportly/presentation/controllers/notification_controller.dart';
import 'package:esportly/presentation/controllers/statistics_controller.dart';

/// Controllers permanentes — criados uma vez, vivem enquanto o app viver
void registerInitControllers() {
  sl.registerSingleton<ThemeController>(ThemeController());
  sl.registerSingleton<AuthController>(AuthController());
  sl.registerSingleton<NavigationController>(NavigationController());
  sl.registerSingleton<ShowcaseController>(ShowcaseController());
  sl.registerLazySingleton<UserController>(() => UserController());
  sl.registerLazySingleton<HomeController>(() => HomeController());
  sl.registerLazySingleton<AppController>(() => AppController());
}

/// Controllers lazy — instanciados apenas quando chamados pela primeira vez
void registerLazyControllers() {
  sl.registerLazySingleton<EventController>(() => EventController());
  sl.registerLazySingleton<StatisticsController>(() => StatisticsController());
  sl.registerLazySingleton<RankController>(() => RankController());
  sl.registerLazySingleton<ExplorerController>(() => ExplorerController());
  sl.registerLazySingleton<ChatController>(() => ChatController());
  sl.registerLazySingleton<NotificationController>(() => NotificationController());
}