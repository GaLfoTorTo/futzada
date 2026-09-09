import 'package:esportly/core/di/service_locator.dart';
import 'package:esportly/data/repositories/escalation_repository.dart';
import 'package:esportly/data/repositories/event_repository.dart';
import 'package:esportly/data/repositories/user_repository.dart';

//FUNÇÃO DE INICIALIZAÇÃO DE REPOSITÓRIOS — chamada no início do app
Future<void> registerRepositories() async {
  sl.registerLazySingleton<UserRepository>(() => UserRepository());  
  sl.registerLazySingleton<EventRepository>(() => EventRepository());  
  sl.registerLazySingleton<EscalationRepository>(() => EscalationRepository());  
}