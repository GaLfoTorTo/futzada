import 'package:futzada/core/di/service_locator.dart';
import 'package:futzada/data/repositories/escalation_repository.dart';
import 'package:futzada/data/repositories/event_repository.dart';
import 'package:futzada/data/repositories/game_repository.dart';
import 'package:futzada/data/repositories/user_repository.dart';

//FUNÇÃO DE INICIALIZAÇÃO DE REPOSITÓRIOS — chamada no início do app
Future<void> registerRepositories() async {
  sl.registerLazySingleton<UserRepository>(() => UserRepository());  
  sl.registerLazySingleton<EventRepository>(() => EventRepository());  
  sl.registerLazySingleton<GameRepository>(() => GameRepository());  
  sl.registerLazySingleton<EscalationRepository>(() => EscalationRepository());  
}